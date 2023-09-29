import random
import pandas as pd
import matplotlib.pyplot as plt


def simulate():
    # Possible boarding duration for a passenger (individual) in seconds
    boarding_durations = [1, 2, 3, 6, 8, 12]

    # 7 train cars, giving priority to central cars by adding them more times (explained below)
    train_cars = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7]

    total_boarding_duration_per_car = [0 for car in set(train_cars)]
    passengers_per_car = [0 for car in set(train_cars)]
    total_boarding_duration = 0  # the max boarding duration to a train car
    total_passengers = 0

    # Assuming there is enough available seats for all the passengers waiting on the station (in the car they choose)
    # For each of the 100 passengers waiting on the railway, we'll randomly choose a boarding duration and a train car.
    # We'll give an advantage to the central cars, since passengers usually choose them (closer to entrances & exits).
    for passenger in range(100):
        dur_i = random.randint(0, len(boarding_durations) - 1)
        boarding_dur = boarding_durations[dur_i]
        car = random.choice(train_cars) - 1

        total_boarding_duration_per_car[car] += boarding_dur
        passengers_per_car[car] += 1

    for i in range(len(set(train_cars))):
        if total_boarding_duration_per_car[i] > total_boarding_duration:
            total_boarding_duration = total_boarding_duration_per_car[i]

    # Creating an Excel file with the data. Note - in the 'Total' column, the total boarding time is a max & not a sum.
    df = pd.DataFrame({'Train_Cars': ["Car 1", "Car 2", "Car 3", "Car 4", "Car 5", "Car 6", "Car 7"],
                       'Passenger_Num': passengers_per_car,
                       'Boarding_Duration_sec': total_boarding_duration_per_car})

    values = df[['Train_Cars', 'Boarding_Duration_sec']]
    graph = values.plot.bar(x='Train_Cars', y='Boarding_Duration_sec', rot=0)
    plt.show()
    df.to_excel('./Train_Simulation.xlsx')


if __name__ == '__main__':
    simulate()
