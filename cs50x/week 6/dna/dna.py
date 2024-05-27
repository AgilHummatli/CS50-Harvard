import csv
import sys


def main():

    # Check for command-line usage: we need the script name, the CSV, and the TXT file
    if len(sys.argv) != 3:
        print("Usage: python dna.py data.csv sequence.txt")
        sys.exit(1)

    # Read database file into a variable
    # Using DictReader makes it easy to access STR counts by their header names
    database = []
    with open(sys.argv[1], "r") as file:
        reader = csv.DictReader(file)
        # Store the STR names (column headers) excluding 'name'
        strs = reader.fieldnames[1:]
        for row in reader:
            database.append(row)

    # Read DNA sequence file into a variable
    with open(sys.argv[2], "r") as file:
        dna_sequence = file.read()

    # Find longest match of each STR in DNA sequence
    # We store the results in a dictionary where key = STR and value = max repeats
    results = {}
    for s in strs:
        results[s] = longest_match(dna_sequence, s)

    # Check database for matching profiles
    # Iterate through each person in our database (each 'row' from the CSV)
    for person in database:
        match_count = 0

        # Compare the counts for every STR we found in the sequence
        for s in strs:
            # Remember: CSV data is read as strings, so cast to int for comparison!
            if int(person[s]) == results[s]:
                match_count += 1

        # If all STR counts match, we found our person
        if match_count == len(strs):
            print(person["name"])
            return

    # If the loop finishes without returning, no one matched perfectly
    print("No match")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in sequence, return longest run found
    return longest_run


if __name__ == "__main__":
    main()
