#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// Each candidate has a name and vote count
typedef struct
{
    string name;
    int votes;
} candidate;

// Global array of candidates
candidate candidates[MAX];
int candidate_count;

// Function prototypes
bool vote(string name);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check that at least one candidate is provided
    if (argc < 2)
    {
        printf("Usage: ./plurality [candidate ...]\n");
        return 1;
    }

    // Populate candidates array and initialize vote counts
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %d\n", MAX);
        return 1;
    }

    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
    }

    // Ask for number of voters
    int voter_count = get_int("Number of voters: ");

    // Loop over all voters
    for (int i = 0; i < voter_count; i++)
    {
        string name = get_string("Vote: ");

        // Check if vote is valid
        if (!vote(name))
        {
            printf("Invalid vote.\n");
        }
    }

    // Display the winner of the election
    print_winner();
}

// Update vote totals given a new vote
bool vote(string name)
{
    for (int i = 0; i < candidate_count; i++)
    {
        // Compare input name with candidate names
        if (strcmp(name, candidates[i].name) == 0)
        {
            candidates[i].votes++; // increment vote count
            return true;
        }
    }
    return false; // name did not match any candidate
}

// Print the winner(s) of the election
void print_winner(void)
{
    int max_votes = 0;

    // Find highest vote count
    for (int i = 0; i < candidate_count; i++)
    {
        if (candidates[i].votes > max_votes)
        {
            max_votes = candidates[i].votes;
        }
    }

    // Print all candidates who have max votes (handle ties)
    for (int i = 0; i < candidate_count; i++)
    {
        if (candidates[i].votes == max_votes)
        {
            printf("%s\n", candidates[i].name);
        }
    }
}
