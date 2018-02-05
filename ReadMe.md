

```python
import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import datetime
from jupyterthemes import jtplot
```


```python
# Import data
csv_path = 'GDA_DATA.csv'
df = pd.read_csv(csv_path, encoding='ISO-8859-1')
```


```python
# Rename Columns
col_name = ['trip_id', 'duration', 'start_date', 'start_station', 'start_terminal', 'end_date', 'end_station', 'end_terminal', 'bike_no', 'subscriber_type', 'zip_code']
df.columns = col_name
df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>trip_id</th>
      <th>duration</th>
      <th>start_date</th>
      <th>start_station</th>
      <th>start_terminal</th>
      <th>end_date</th>
      <th>end_station</th>
      <th>end_terminal</th>
      <th>bike_no</th>
      <th>subscriber_type</th>
      <th>zip_code</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>432946</td>
      <td>406</td>
      <td>8/31/2014 22:31</td>
      <td>Mountain View Caltrain Station</td>
      <td>28</td>
      <td>8/31/2014 22:38</td>
      <td>Castro Street and El Camino Real</td>
      <td>32</td>
      <td>17</td>
      <td>Subscriber</td>
      <td>94040</td>
    </tr>
    <tr>
      <th>1</th>
      <td>432945</td>
      <td>468</td>
      <td>8/31/2014 22:07</td>
      <td>Beale at Market</td>
      <td>56</td>
      <td>8/31/2014 22:15</td>
      <td>Market at 4th</td>
      <td>76</td>
      <td>509</td>
      <td>Customer</td>
      <td>11231</td>
    </tr>
    <tr>
      <th>2</th>
      <td>432944</td>
      <td>534</td>
      <td>8/31/2014 22:06</td>
      <td>Beale at Market</td>
      <td>56</td>
      <td>8/31/2014 22:15</td>
      <td>Market at 4th</td>
      <td>76</td>
      <td>342</td>
      <td>Customer</td>
      <td>11231</td>
    </tr>
    <tr>
      <th>3</th>
      <td>432942</td>
      <td>1041</td>
      <td>8/31/2014 21:45</td>
      <td>Embarcadero at Sansome</td>
      <td>60</td>
      <td>8/31/2014 22:02</td>
      <td>Steuart at Market</td>
      <td>74</td>
      <td>603</td>
      <td>Customer</td>
      <td>94521</td>
    </tr>
    <tr>
      <th>4</th>
      <td>432941</td>
      <td>1091</td>
      <td>8/31/2014 21:44</td>
      <td>Embarcadero at Sansome</td>
      <td>60</td>
      <td>8/31/2014 22:02</td>
      <td>Steuart at Market</td>
      <td>74</td>
      <td>598</td>
      <td>Customer</td>
      <td>94521</td>
    </tr>
  </tbody>
</table>
</div>



# Functions


```python
# Extract Time
def get_time(date_time):
    reformatted_time = datetime.datetime.strptime(date_time, '%m/%d/%Y %H:%M')
    reformatted_time = reformatted_time.strftime("%H:00")
    return reformatted_time
```


```python
# Plot Supply vs Demand given Station
def plt_supply_demand(station):
    # Set up axis
    x_axis = top_stations_df.time
    y_axis_demand = top_stations_df.loc[top_stations_df.station == station].demand_count
    y_axis_supply = top_stations_df.loc[top_stations_df.station == station].supply_count
    #Plot
    fig, ax = plt.subplots(1, 1, figsize=(30, 10))
    fig.suptitle("Bike Share Hourly Supply vs Demand @ "+station, fontsize=24, fontweight="bold")
    colors = {'Supply':'lightblue', 'Demand':'lightcoral'}
    ax.plot(x_axis[top_stations_df.station == station], y_axis_demand[top_stations_df.station == station], marker="o", c="lightcoral", linewidth=7.0, alpha=0.75, label = "Demand")
    ax.plot(x_axis[top_stations_df.station == station], y_axis_supply[top_stations_df.station == station], marker="o", c="lightblue", linewidth=7.0, alpha=0.75, label = "Supply")
    
    ax.set_ylabel('Number of Bikes')
    ax.set_xlabel('Time')
    plt.legend(loc="upper left", fancybox=True)
    
    # Set Style
    jtplot.style(theme='onedork')
    plt.show()
```


```python
 def plt_inv_target(station):
    # Set up axis
    x_axis = inv_target_hourly_df.time
    y_axis = inv_target_hourly_df.loc[inv_target_hourly_df.station == station].inventory_target
    y_axis_supply = inv_target_hourly_df.loc[inv_target_hourly_df.station == station].supply_count
    y_axis_demand = inv_target_hourly_df.loc[inv_target_hourly_df.station == station].demand_count
 
    #Plot
    fig, ax = plt.subplots(1, 1, figsize=(30, 10))
    fig.suptitle("Bike Share Hourly Inventory Target @ "+station, fontsize=24, fontweight="bold")
    colors = {'Inv Target': 'darkblue', 'Supply':'lightblue', 'Demand':'lightcoral'}
    
    ax.bar(x_axis[inv_target_hourly_df.station == station], y_axis[inv_target_hourly_df.station == station], color="darkblue", width=1.0, alpha=0.75, label = 'Inventory Target')
    ax.plot(x_axis[inv_target_hourly_df.station == station], y_axis_demand[inv_target_hourly_df.station == station], marker="o", c="lightcoral", linewidth=7.0, alpha=0.75, label = "Demand")
    ax.plot(x_axis[inv_target_hourly_df.station == station], y_axis_supply[inv_target_hourly_df.station == station], marker="o", c="lightblue", linewidth=7.0, alpha=0.75, label = "Supply")
    
    ax.set_ylabel('Number of Bikes')
    ax.set_xlabel('Time')
    plt.legend(loc="upper left", fancybox=True)

    # Set Style
    jtplot.style(theme='onedork')
    plt.show()
```


```python
# Calculate Safety Stock. Inventory Targt = Run Rate + Safety Stock
def calc_safety_stock(sl, avg_d, std_d, avg_s, std_s):
    ss = stats.norm.ppf(sl)*np.sqrt((avg_d**2)*(std_s**2) + avg_s*(std_d**2))
    return ss

```

# Identify High Demand & Supply Stations

## Extract Time


```python
df['start_time'] = df.start_date.apply(get_time)
df['end_time'] = df.end_date.apply(get_time)
```


```python
df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>trip_id</th>
      <th>duration</th>
      <th>start_date</th>
      <th>start_station</th>
      <th>start_terminal</th>
      <th>end_date</th>
      <th>end_station</th>
      <th>end_terminal</th>
      <th>bike_no</th>
      <th>subscriber_type</th>
      <th>zip_code</th>
      <th>start_time</th>
      <th>end_time</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>432946</td>
      <td>406</td>
      <td>8/31/2014 22:31</td>
      <td>Mountain View Caltrain Station</td>
      <td>28</td>
      <td>8/31/2014 22:38</td>
      <td>Castro Street and El Camino Real</td>
      <td>32</td>
      <td>17</td>
      <td>Subscriber</td>
      <td>94040</td>
      <td>22:00</td>
      <td>22:00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>432945</td>
      <td>468</td>
      <td>8/31/2014 22:07</td>
      <td>Beale at Market</td>
      <td>56</td>
      <td>8/31/2014 22:15</td>
      <td>Market at 4th</td>
      <td>76</td>
      <td>509</td>
      <td>Customer</td>
      <td>11231</td>
      <td>22:00</td>
      <td>22:00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>432944</td>
      <td>534</td>
      <td>8/31/2014 22:06</td>
      <td>Beale at Market</td>
      <td>56</td>
      <td>8/31/2014 22:15</td>
      <td>Market at 4th</td>
      <td>76</td>
      <td>342</td>
      <td>Customer</td>
      <td>11231</td>
      <td>22:00</td>
      <td>22:00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>432942</td>
      <td>1041</td>
      <td>8/31/2014 21:45</td>
      <td>Embarcadero at Sansome</td>
      <td>60</td>
      <td>8/31/2014 22:02</td>
      <td>Steuart at Market</td>
      <td>74</td>
      <td>603</td>
      <td>Customer</td>
      <td>94521</td>
      <td>21:00</td>
      <td>22:00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>432941</td>
      <td>1091</td>
      <td>8/31/2014 21:44</td>
      <td>Embarcadero at Sansome</td>
      <td>60</td>
      <td>8/31/2014 22:02</td>
      <td>Steuart at Market</td>
      <td>74</td>
      <td>598</td>
      <td>Customer</td>
      <td>94521</td>
      <td>21:00</td>
      <td>22:00</td>
    </tr>
  </tbody>
</table>
</div>



## Identify Top 5 Demand Station


```python
rank_demand_df = df.groupby(['start_station','start_terminal']).count()
rank_demand_df = pd.DataFrame(rank_demand_df['start_date'])
rank_demand_df.sort_values(by=['start_date'],ascending=False,inplace=False).head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>start_date</th>
    </tr>
    <tr>
      <th>start_station</th>
      <th>start_terminal</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>San Francisco Caltrain (Townsend at 4th)</th>
      <th>70</th>
      <td>12950</td>
    </tr>
    <tr>
      <th>Harry Bridges Plaza (Ferry Building)</th>
      <th>50</th>
      <td>8336</td>
    </tr>
    <tr>
      <th>Embarcadero at Sansome</th>
      <th>60</th>
      <td>7010</td>
    </tr>
    <tr>
      <th>San Francisco Caltrain 2 (330 Townsend)</th>
      <th>69</th>
      <td>7008</td>
    </tr>
    <tr>
      <th>2nd at Townsend</th>
      <th>61</th>
      <td>6824</td>
    </tr>
  </tbody>
</table>
</div>



## Identify Top 5 Supply Station


```python
rank_supply_df = df.groupby(['end_station','end_terminal']).count()
rank_supply_df = pd.DataFrame(rank_supply_df['end_date'])
rank_supply_df.sort_values(by=['end_date'],ascending=False,inplace=False).head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>end_date</th>
    </tr>
    <tr>
      <th>end_station</th>
      <th>end_terminal</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>San Francisco Caltrain (Townsend at 4th)</th>
      <th>70</th>
      <td>16732</td>
    </tr>
    <tr>
      <th>Embarcadero at Sansome</th>
      <th>60</th>
      <td>8141</td>
    </tr>
    <tr>
      <th>Harry Bridges Plaza (Ferry Building)</th>
      <th>50</th>
      <td>7908</td>
    </tr>
    <tr>
      <th>Market at Sansome</th>
      <th>77</th>
      <td>7879</td>
    </tr>
    <tr>
      <th>San Francisco Caltrain 2 (330 Townsend)</th>
      <th>69</th>
      <td>7482</td>
    </tr>
  </tbody>
</table>
</div>



## Work on Top 3 Stations 
### (San Francisco Caltrain (Townsend at 4th), Embarcadero at Sansome, Harry Bridges Plaza (Ferry Building))

### Definition: 
*  Demand: Number of bikes checked out from a station
*  Supply: Number of bikes returned to a station


```python
# To Merge the DFs: Extract and change columns to the same column names
demand_df = df.loc[:,['start_terminal','start_station','start_time', 'trip_id']]
demand_df.rename(columns = {
                            'start_terminal': 'terminal',
                            'start_station': 'station',
                            'start_time': 'time',
                            'trip_id': 'demand_count'
                            },
                            inplace = True
                )
# Get count for each station and each time
grouped_demand_df = demand_df.groupby(['terminal', 'station', 'time'])
grouped_demand_count_df = grouped_demand_df.count()
demand_df = grouped_demand_count_df.reset_index()
```


```python
# To Merge the DFs: Extract and change columns to the same column names
supply_df = df.loc[:,['end_terminal', 'end_station','end_time', 'trip_id']]
supply_df.rename(columns = {
                            'end_terminal': 'terminal',
                            'end_station': 'station',
                            'end_time': 'time',
                            'trip_id': 'supply_count'
                            },
                            inplace = True
                )
# Get count for each station and each time
grouped_supply_df = supply_df.groupby(['terminal', 'station', 'time'])
grouped_supply_count_df = grouped_supply_df.count()
supply_df = grouped_supply_count_df.reset_index()
```


```python
stations_df = pd.merge(demand_df, supply_df, on = ['terminal', 'station', 'time'], how = 'inner')
```

### Normalize the DataFrame to Reflect Daily Demand and Supply

### Notes:
- The data provides 184 days of data (from Mar 1st to Sep 1st). To show daily run rate for demand and supply, I **divide the count columns by 184 days**


```python
# Calculate Number of Days in the original dataset
dates_df = pd.concat([df.start_date,df.end_date])
max_date = datetime.datetime.strptime(dates_df.max(), '%m/%d/%Y %H:%M')
min_date = datetime.datetime.strptime(dates_df.min(), '%m/%d/%Y %H:%M')
num_days = (max_date - min_date).days
normalize_daily = lambda x:round(x/num_days,2)
```


```python
# Normalize the demand and supply columns
stations_df.demand_count = stations_df.demand_count.apply(normalize_daily)
stations_df.supply_count = stations_df.supply_count.apply(normalize_daily)
```


```python
top_stations_df = stations_df.set_index('terminal')
top_stations_df = top_stations_df.loc[[70, 50, 60],:]
top_stations_df = top_stations_df.reset_index()
top_stations_df.head(24)
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>time</th>
      <th>demand_count</th>
      <th>supply_count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>00:00</td>
      <td>0.14</td>
      <td>0.14</td>
    </tr>
    <tr>
      <th>1</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>01:00</td>
      <td>0.08</td>
      <td>0.11</td>
    </tr>
    <tr>
      <th>2</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>02:00</td>
      <td>0.04</td>
      <td>0.04</td>
    </tr>
    <tr>
      <th>3</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>03:00</td>
      <td>0.01</td>
      <td>0.01</td>
    </tr>
    <tr>
      <th>4</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>04:00</td>
      <td>0.01</td>
      <td>0.03</td>
    </tr>
    <tr>
      <th>5</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>05:00</td>
      <td>0.22</td>
      <td>0.10</td>
    </tr>
    <tr>
      <th>6</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>06:00</td>
      <td>2.96</td>
      <td>1.72</td>
    </tr>
    <tr>
      <th>7</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>07:00</td>
      <td>11.55</td>
      <td>6.16</td>
    </tr>
    <tr>
      <th>8</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>08:00</td>
      <td>17.79</td>
      <td>9.08</td>
    </tr>
    <tr>
      <th>9</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>09:00</td>
      <td>9.25</td>
      <td>4.61</td>
    </tr>
    <tr>
      <th>10</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>10:00</td>
      <td>2.61</td>
      <td>1.88</td>
    </tr>
    <tr>
      <th>11</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>11:00</td>
      <td>1.66</td>
      <td>1.17</td>
    </tr>
    <tr>
      <th>12</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>12:00</td>
      <td>1.28</td>
      <td>1.49</td>
    </tr>
    <tr>
      <th>13</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>13:00</td>
      <td>1.11</td>
      <td>1.57</td>
    </tr>
    <tr>
      <th>14</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>14:00</td>
      <td>0.98</td>
      <td>1.77</td>
    </tr>
    <tr>
      <th>15</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>15:00</td>
      <td>1.15</td>
      <td>3.56</td>
    </tr>
    <tr>
      <th>16</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>16:00</td>
      <td>1.89</td>
      <td>15.45</td>
    </tr>
    <tr>
      <th>17</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>17:00</td>
      <td>5.48</td>
      <td>19.45</td>
    </tr>
    <tr>
      <th>18</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>18:00</td>
      <td>5.59</td>
      <td>13.80</td>
    </tr>
    <tr>
      <th>19</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>19:00</td>
      <td>3.72</td>
      <td>3.80</td>
    </tr>
    <tr>
      <th>20</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>20:00</td>
      <td>1.24</td>
      <td>2.48</td>
    </tr>
    <tr>
      <th>21</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>21:00</td>
      <td>0.71</td>
      <td>1.50</td>
    </tr>
    <tr>
      <th>22</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>22:00</td>
      <td>0.61</td>
      <td>0.60</td>
    </tr>
    <tr>
      <th>23</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>23:00</td>
      <td>0.30</td>
      <td>0.40</td>
    </tr>
  </tbody>
</table>
</div>



# Identify Supply and Demand Gap


```python
station_list = top_stations_df.station.unique()
for station in station_list:
    plt_supply_demand(station)
```


![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_27_0.png)



![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_27_1.png)



![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_27_2.png)


## Problem Statement: Inbalanced Supply and Demand
The issue that I encountered in the past for bike rental is that all the bikes were checked out or the racks were full when returning the bike. Therefore, I decided to dig deeper on the issue of supply and demand gap. The charts above show there is indeed supply and demand gaps for top 3 major bike stations.

## Mission Statement: Suggest a Quantified Solution to Bridge Supply and Dmand Gap
I applied the supply chain knowledge of inventory target to prevent the events of stockout (no bikes available) or surplus (racks are full)

## Validation: Hopythesis Testing
To experiment the solution soundess, I designed a Time Series 1-sided T-Test to validate if the inventory sugestion indeed lowers the supply and demand gaps.

## Tool: Dashboard
A dashboard is designed to coninue the experiment through time.


# Suggest Hourly Bikes Inventory Target to Improve Utilization at each Station

## Calculate the Optimal Inventory Level
### Notes:
- Predicting the hourly inventory target at each station can prevent bikes shortage or surplus at any bike station

### Steps:
1. Measure Demand and Supply Variabilities
2. Define Service Level for each hour at each station (How well do we want to service our customer)
3. Calculate Safety Stock and Optimal Inventory Level (# of bikes to hold to prevent stockout) 

### Formula:
- **Inventory Target (IT) = Average Hourly Run Rate (AHR) + Safety Stock (SS)**
   - AHR = demand_avg
   - SS = service level(%) * the vector of demand and supply variabilities
       - Variability can be measured by historical demand (# of bikes checked out) and supply (# of bikes returned) using **mean** and **std**
- The Supply vs Demand Graphs show there are two peaks in supply and demand throughout the day.
   - To better measure the supply and demand variabilities, I split the daily dataframe into AM and PM
    


```python
inv_target_am_df = stations_df.loc[stations_df.time < '13:00']
inv_target_pm_df = stations_df.loc[stations_df.time >= '13:00']
```

## Step 1: Measure the Demand and Supply Variabilities: Calculate mean and std for each station

#### Calculate meand and std for DataFrame AM


```python
grouped_inv_target_am_df = inv_target_am_df.groupby(['terminal', 'station'])
#avg
avg_df = grouped_inv_target_am_df.mean()
avg_df = avg_df.reset_index()
avg_df = avg_df.rename(columns={'demand_count': 'demand_avg',
                                'supply_count': 'supply_avg'}
                                )
#std
std_df = grouped_inv_target_am_df.std().fillna(grouped_inv_target_am_df.last())
std_df = std_df.reset_index()
std_df = std_df.rename(columns={'demand_count': 'demand_std',
                                'supply_count': 'supply_std'}
                                )
inv_target_am_df = pd.merge(avg_df, std_df, on=['terminal', 'station'], how = 'inner')
```


```python
inv_target_am_df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>demand_avg</th>
      <th>supply_avg</th>
      <th>demand_std</th>
      <th>supply_std</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>0.687000</td>
      <td>0.500000</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>San Jose Civic Center</td>
      <td>0.113750</td>
      <td>0.101250</td>
      <td>0.102670</td>
      <td>0.083399</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4</td>
      <td>Santa Clara at Almaden</td>
      <td>0.143636</td>
      <td>0.255455</td>
      <td>0.127536</td>
      <td>0.339834</td>
    </tr>
    <tr>
      <th>3</th>
      <td>5</td>
      <td>Adobe on Almaden</td>
      <td>0.058571</td>
      <td>0.190000</td>
      <td>0.069625</td>
      <td>0.151217</td>
    </tr>
    <tr>
      <th>4</th>
      <td>6</td>
      <td>San Pedro Square</td>
      <td>0.080000</td>
      <td>0.175455</td>
      <td>0.051962</td>
      <td>0.225671</td>
    </tr>
  </tbody>
</table>
</div>



#### Calculate mean and std for DataFrame PM


```python
grouped_inv_target_pm_df = inv_target_pm_df.groupby(['terminal', 'station'])
#avg
avg_df = grouped_inv_target_pm_df.mean()
avg_df = avg_df.reset_index()
avg_df = avg_df.rename(columns={'demand_count': 'demand_avg',
                                'supply_count': 'supply_avg'}
                                )
#std
std_df = grouped_inv_target_pm_df.std().fillna(grouped_inv_target_pm_df.last())
std_df = std_df.reset_index()
std_df = std_df.rename(columns={'demand_count': 'demand_std',
                                'supply_count': 'supply_std'}
                                )
inv_target_pm_df = pd.merge(avg_df, std_df, on=['terminal', 'station'], how = 'inner')
```


```python
inv_target_pm_df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>demand_avg</th>
      <th>supply_avg</th>
      <th>demand_std</th>
      <th>supply_std</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>0.668182</td>
      <td>0.752727</td>
      <td>0.739295</td>
      <td>1.135465</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>San Jose Civic Center</td>
      <td>0.140909</td>
      <td>0.173636</td>
      <td>0.078033</td>
      <td>0.108099</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4</td>
      <td>Santa Clara at Almaden</td>
      <td>0.329091</td>
      <td>0.262727</td>
      <td>0.432422</td>
      <td>0.150472</td>
    </tr>
    <tr>
      <th>3</th>
      <td>5</td>
      <td>Adobe on Almaden</td>
      <td>0.158000</td>
      <td>0.055000</td>
      <td>0.153608</td>
      <td>0.039511</td>
    </tr>
    <tr>
      <th>4</th>
      <td>6</td>
      <td>San Pedro Square</td>
      <td>0.305455</td>
      <td>0.200909</td>
      <td>0.275186</td>
      <td>0.117000</td>
    </tr>
  </tbody>
</table>
</div>



#### Concatinate AM and PM Dataframes with Hourly Dataframe


```python
inv_target_hourly_df = stations_df
inv_target_hourly_df.drop(['demand_count','supply_count'],axis='columns',inplace=False).head(0)

# merge df contains mean, std information with df contains hourly information
inv_target_hourly_am_df = pd.merge(inv_target_hourly_df.loc[inv_target_hourly_df.time<'13:00'],inv_target_am_df,on=['terminal','station'], how='left')
inv_target_hourly_pm_df = pd.merge(inv_target_hourly_df.loc[inv_target_hourly_df.time>='13:00'],inv_target_pm_df,on=['terminal','station'], how='left')

# Concatinate the AM and PM DataFrames
frames = [inv_target_hourly_am_df,inv_target_hourly_pm_df]
inv_target_hourly_df = pd.concat(frames)

```


```python
inv_target_hourly_df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>time</th>
      <th>demand_count</th>
      <th>supply_count</th>
      <th>demand_avg</th>
      <th>supply_avg</th>
      <th>demand_std</th>
      <th>supply_std</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>00:00</td>
      <td>0.08</td>
      <td>0.03</td>
      <td>0.687</td>
      <td>0.5</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>01:00</td>
      <td>0.17</td>
      <td>0.01</td>
      <td>0.687</td>
      <td>0.5</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>04:00</td>
      <td>0.01</td>
      <td>0.03</td>
      <td>0.687</td>
      <td>0.5</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>06:00</td>
      <td>0.40</td>
      <td>1.07</td>
      <td>0.687</td>
      <td>0.5</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2</td>
      <td>San Jose Diridon Caltrain Station</td>
      <td>07:00</td>
      <td>1.66</td>
      <td>2.11</td>
      <td>0.687</td>
      <td>0.5</td>
      <td>0.817938</td>
      <td>0.659983</td>
    </tr>
  </tbody>
</table>
</div>



## Step 2: Define Service Level


```python
service_level_df = stations_df
```

#### Calculate Supply and Demand Gap: Demand - Supply Hourly @ each station


```python
service_level_df['delta_demand_supply'] = service_level_df.demand_count - service_level_df.supply_count

service_level_df = service_level_df.sort_values(by=['terminal','station','delta_demand_supply'],ascending=False,inplace=False)
```

#### Calculate Demand - Supply Percentile for each Station


```python
service_level_df['percentile'] = service_level_df.loc[service_level_df['delta_demand_supply']>0.5].groupby(['terminal','station'])['delta_demand_supply'].rank(pct=True)
service_level_df = service_level_df.fillna(0)
```

### Notes:
The Pareto Analysis is used to determine the service level at each station throughout the day:
- the **95%** service level is assigned to percentile **above  80%**
- the **80%** service level is assigned to percentile ranging from **15% to 80%** 
- the **75%** service level is assigned to percentile ranging from  **5% to 15%**
- the **50%** service level is assigned to percentile **below 5%**


```python
service_level_bins = [-1, .05, .15, .80, 1]
service_level_label = [.50, .75, .80, .95]
service_level_df["service_level"] = pd.cut(service_level_df.percentile, service_level_bins, labels=service_level_label)
```


```python
service_level_df.loc[service_level_df.terminal==70].sort_values(by=['terminal','station'],ascending=True,inplace=False).head(24)
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>time</th>
      <th>demand_count</th>
      <th>supply_count</th>
      <th>delta_demand_supply</th>
      <th>percentile</th>
      <th>service_level</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1145</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>08:00</td>
      <td>17.79</td>
      <td>9.08</td>
      <td>8.71</td>
      <td>1.0</td>
      <td>0.95</td>
    </tr>
    <tr>
      <th>1144</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>07:00</td>
      <td>11.55</td>
      <td>6.16</td>
      <td>5.39</td>
      <td>0.8</td>
      <td>0.80</td>
    </tr>
    <tr>
      <th>1146</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>09:00</td>
      <td>9.25</td>
      <td>4.61</td>
      <td>4.64</td>
      <td>0.6</td>
      <td>0.80</td>
    </tr>
    <tr>
      <th>1143</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>06:00</td>
      <td>2.96</td>
      <td>1.72</td>
      <td>1.24</td>
      <td>0.4</td>
      <td>0.80</td>
    </tr>
    <tr>
      <th>1147</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>10:00</td>
      <td>2.61</td>
      <td>1.88</td>
      <td>0.73</td>
      <td>0.2</td>
      <td>0.80</td>
    </tr>
    <tr>
      <th>1148</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>11:00</td>
      <td>1.66</td>
      <td>1.17</td>
      <td>0.49</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1142</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>05:00</td>
      <td>0.22</td>
      <td>0.10</td>
      <td>0.12</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1159</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>22:00</td>
      <td>0.61</td>
      <td>0.60</td>
      <td>0.01</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1137</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>00:00</td>
      <td>0.14</td>
      <td>0.14</td>
      <td>0.00</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1139</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>02:00</td>
      <td>0.04</td>
      <td>0.04</td>
      <td>0.00</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1140</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>03:00</td>
      <td>0.01</td>
      <td>0.01</td>
      <td>0.00</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1141</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>04:00</td>
      <td>0.01</td>
      <td>0.03</td>
      <td>-0.02</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1138</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>01:00</td>
      <td>0.08</td>
      <td>0.11</td>
      <td>-0.03</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1156</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>19:00</td>
      <td>3.72</td>
      <td>3.80</td>
      <td>-0.08</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1160</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>23:00</td>
      <td>0.30</td>
      <td>0.40</td>
      <td>-0.10</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1149</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>12:00</td>
      <td>1.28</td>
      <td>1.49</td>
      <td>-0.21</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1150</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>13:00</td>
      <td>1.11</td>
      <td>1.57</td>
      <td>-0.46</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1151</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>14:00</td>
      <td>0.98</td>
      <td>1.77</td>
      <td>-0.79</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1158</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>21:00</td>
      <td>0.71</td>
      <td>1.50</td>
      <td>-0.79</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1157</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>20:00</td>
      <td>1.24</td>
      <td>2.48</td>
      <td>-1.24</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1152</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>15:00</td>
      <td>1.15</td>
      <td>3.56</td>
      <td>-2.41</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1155</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>18:00</td>
      <td>5.59</td>
      <td>13.80</td>
      <td>-8.21</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1153</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>16:00</td>
      <td>1.89</td>
      <td>15.45</td>
      <td>-13.56</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
    <tr>
      <th>1154</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>17:00</td>
      <td>5.48</td>
      <td>19.45</td>
      <td>-13.97</td>
      <td>0.0</td>
      <td>0.50</td>
    </tr>
  </tbody>
</table>
</div>



## Step 3: Calculate Safety Stock and Inventory Target

#### **Safety Stock **is to prevent stockout due to demand and supply variabilities. Demand and Supply Variabilities were calculated in Step 1 for each station at each hour.
$$ Safety\ Stock == z (p)\sqrt{\mu_d^2 \sigma_{LT}^2 + \mu_{LT} \sigma_d^2}$$
$$p: Service\ Level$$
$$\mu_d: Average\ Demand$$
$$\sigma_{LT}:Std\ Dev\ of\ Supply\ Lead|Time$$
$$\mu_{LT}: Average\ Supply\ Lead\ Time$$
$$\sigma_d: Std\ Dev\ of\ Demand$$

#### **Inventory Target** can be calculated with the sum of average hourly run rate and safety stock. In this analysis, I sum up the avg_demand and the safety stock for each station at each hour.


```python
# Merge service level calculated in step 2 to the inv_target_hourly_df DataFrame
inv_target_hourly_df = pd.merge(inv_target_hourly_df, service_level_df.loc[:,['terminal','station','time','delta_demand_supply', 'service_level']],on=['terminal','station','time'], how='inner')
```

#### Calculate Safety Stock


```python
# Assign attributes
sl = inv_target_hourly_df.service_level
std_d = inv_target_hourly_df.demand_std
avg_d = inv_target_hourly_df.demand_avg
avg_s = inv_target_hourly_df.supply_avg
std_s = inv_target_hourly_df.supply_std

inv_target_hourly_df['safety_stock'] = calc_safety_stock(sl, avg_d, std_d, avg_s, std_s)
```

#### Calculate Inventory Target


```python
inv_target_hourly_df['inventory_target'] = inv_target_hourly_df.demand_avg + inv_target_hourly_df.safety_stock 
inv_target_hourly_df = inv_target_hourly_df.round(2)
inv_target_hourly_df.inventory_target = inv_target_hourly_df.inventory_target.apply(np.ceil)
```


```python
inv_target_hourly_df.loc[inv_target_hourly_df.terminal == 70]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>terminal</th>
      <th>station</th>
      <th>time</th>
      <th>demand_count</th>
      <th>supply_count</th>
      <th>demand_avg</th>
      <th>supply_avg</th>
      <th>demand_std</th>
      <th>supply_std</th>
      <th>delta_demand_supply</th>
      <th>service_level</th>
      <th>safety_stock</th>
      <th>inventory_target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>535</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>00:00</td>
      <td>0.14</td>
      <td>0.14</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.00</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>536</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>01:00</td>
      <td>0.08</td>
      <td>0.11</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>-0.03</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>537</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>02:00</td>
      <td>0.04</td>
      <td>0.04</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.00</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>538</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>03:00</td>
      <td>0.01</td>
      <td>0.01</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.00</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>539</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>04:00</td>
      <td>0.01</td>
      <td>0.03</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>-0.02</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>540</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>05:00</td>
      <td>0.22</td>
      <td>0.10</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.12</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>541</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>06:00</td>
      <td>2.96</td>
      <td>1.72</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>1.24</td>
      <td>0.80</td>
      <td>11.10</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>542</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>07:00</td>
      <td>11.55</td>
      <td>6.16</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>5.39</td>
      <td>0.80</td>
      <td>11.10</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>543</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>08:00</td>
      <td>17.79</td>
      <td>9.08</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>8.71</td>
      <td>0.95</td>
      <td>21.69</td>
      <td>26.0</td>
    </tr>
    <tr>
      <th>544</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>09:00</td>
      <td>9.25</td>
      <td>4.61</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>4.64</td>
      <td>0.80</td>
      <td>11.10</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>545</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>10:00</td>
      <td>2.61</td>
      <td>1.88</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.73</td>
      <td>0.80</td>
      <td>11.10</td>
      <td>15.0</td>
    </tr>
    <tr>
      <th>546</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>11:00</td>
      <td>1.66</td>
      <td>1.17</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>0.49</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>547</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>12:00</td>
      <td>1.28</td>
      <td>1.49</td>
      <td>3.66</td>
      <td>2.04</td>
      <td>5.64</td>
      <td>2.85</td>
      <td>-0.21</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>1268</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>13:00</td>
      <td>1.11</td>
      <td>1.57</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-0.46</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1269</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>14:00</td>
      <td>0.98</td>
      <td>1.77</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-0.79</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1270</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>15:00</td>
      <td>1.15</td>
      <td>3.56</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-2.41</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1271</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>16:00</td>
      <td>1.89</td>
      <td>15.45</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-13.56</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1272</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>17:00</td>
      <td>5.48</td>
      <td>19.45</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-13.97</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1273</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>18:00</td>
      <td>5.59</td>
      <td>13.80</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-8.21</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1274</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>19:00</td>
      <td>3.72</td>
      <td>3.80</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-0.08</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1275</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>20:00</td>
      <td>1.24</td>
      <td>2.48</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-1.24</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1276</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>21:00</td>
      <td>0.71</td>
      <td>1.50</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-0.79</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1277</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>22:00</td>
      <td>0.61</td>
      <td>0.60</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>0.01</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>1278</th>
      <td>70</td>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>23:00</td>
      <td>0.30</td>
      <td>0.40</td>
      <td>2.07</td>
      <td>5.85</td>
      <td>1.94</td>
      <td>6.87</td>
      <td>-0.10</td>
      <td>0.50</td>
      <td>0.00</td>
      <td>3.0</td>
    </tr>
  </tbody>
</table>
</div>




```python
station_list = top_stations_df.station.unique()
for station in station_list:
    plt_inv_target(station)
```


![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_59_0.png)



![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_59_1.png)



![png](Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_files/Uber%20Freight%20BikeShare_Exercise_GeorgeSu_Final_59_2.png)


#### Wrte the file to CSV
In reality, I would update the DataFrame to a database. That way, the dashboard can monitor the supply demand gap in real time as well as validate the result of the hypothesis in real time.


```python
inv_target_hourly_df.to_csv('bikeshare_inv_target_hourly.csv', sep=',')
```

# Hypothesis Testing

A One-tailed T-Test (small sample size < 30) will be carried out to validate if the inventory target level suggested in this analysis could minimize the supply and demand gap during peak hours at top 3 popular bike stations.
The average of supply and demand gap in absolute value for the top three stations is shown below:
    
    T-Test for Station San Francisco Caltrain (Townsend at 4th):
    H0: Inventory Target does not lower the Supply and Demand Gap, mu = 2.63
    H1: Inventory Target lowers the Supply and Demand Gap, mu < 2.63
        
Conduct a time series T test and see if the t value goes below -1.96.

#### Top 3 Station population mean


```python
sd_gap_avg_df = inv_target_hourly_df.loc[:,['terminal','station','time','delta_demand_supply']]
sd_gap_avg_df['delta_demand_supply'] = sd_gap_avg_df.delta_demand_supply.abs()
grouped_sd_gap_avg_df = sd_gap_avg_df.groupby(['terminal','station'])
sd_gap_avg_df = pd.DataFrame(grouped_sd_gap_avg_df.delta_demand_supply.mean()).reset_index('station')
sd_gap_avg_df.rename(columns={'delta_demand_supply': 'avg supply demand gap'}, inplace = True)
sd_gap_avg_df.loc[[70,50,60],:]

```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>station</th>
      <th>avg supply demand gap</th>
    </tr>
    <tr>
      <th>terminal</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>70</th>
      <td>San Francisco Caltrain (Townsend at 4th)</td>
      <td>2.633333</td>
    </tr>
    <tr>
      <th>50</th>
      <td>Harry Bridges Plaza (Ferry Building)</td>
      <td>1.053913</td>
    </tr>
    <tr>
      <th>60</th>
      <td>Embarcadero at Sansome</td>
      <td>0.566522</td>
    </tr>
  </tbody>
</table>
</div>



# Limitations

#### Below are limitations I encountered in this analysis:
- Potential Supply Constrained
    - Since the data does not provide the actual number of bikes at each station hourly, I might not be capturing the true demand.
    - If there is a supply constrained meaning no bikes available at a station, the customer cannot check out a bike from that station. Therefore, that demand will not be captured.
- Weekend vs Weekday Data
    - There could be different weekday and weekend bike retal behavior. 
    - I made an assumption that they are the same when I aggrepate the data by hours.
    - If I were given more time, I would investigate further on the differences and fine tune the inventory target level.

# Conclusion

- Business Recommendation
    - If we are able to reject the null hypothesis, we can use the inventory target as a prediction model to bridge the supply and demand gap. 
    - The next question then becomes how do we incentivize the bike rider to either rent the bike from nearby station or return the bike at another location.
        - Situation I: Running low on bikes at a station
            - In the case that the inventory is low, we want to encourage bike riders to return their bikes to this location. Or we want the bike renters to rent at another nearby location if they are willing to accept the incentives.
        - Situation II: Too many bikes at a station
            - In the case the the inventory is surplus, we want to encourage bike renters to rent their bikes at this location. Or we want the bike riders to return at another nearby location if they are willing to accept the incentives.
    - Incentives
        - Extra minutes on the bike
        - Discount on Uber Pool
- How to use the tool for real time monitoring
    - The dashboard along with this Python script will allow the business stakeholders to see the latest Supply and Demand relationship.
    - The inventory target is also updated in realtime when new data comes in.
    - Prediction Model with Inventory Target
        - If we can forecast the future demand, then we can also calculate the future inventory target.
        - If we can predetermine the future inventory target, then we can launch the campaign to rebalance the supply and demand ahead of time. 
