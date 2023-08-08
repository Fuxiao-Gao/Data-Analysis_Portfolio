import csv

def replace_empty_slots(filename, start_column, end_column):
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        data = list(reader)

    for row in data:
        for i in range(start_column, end_column + 1):
            if not row[i]:
                row[i] = 0

    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(data)


def convert_index(column_label):
    index = 0

    for char in column_label:
        index = index * 26 + (ord(char) - ord('A') + 1)
    return index - 1


filename = 'covidVaccination.csv'

start_column = convert_index('E')
end_column = convert_index('L')

replace_empty_slots(filename, start_column, end_column)