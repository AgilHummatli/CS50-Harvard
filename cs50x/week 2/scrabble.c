#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

// Point values for letters A-Z based on the table
int points[26] = {
    1,  // A
    3,  // B
    3,  // C
    2,  // D
    1,  // E
    4,  // F
    2,  // G
    4,  // H
    1,  // I
    8,  // J
    5,  // K
    1,  // L
    3,  // M
    1,  // N
    1,  // O
    3,  // P
    10, // Q
    1,  // R
    1,  // S
    1,  // T
    1,  // U
    4,  // V
    4,  // W
    8,  // X
    4,  // Y
    10  // Z
};

// Function to compute score of a word
int compute_score(string word)
{
    int score = 0;

    // Loop through each character in the string
    for (int i = 0, n = strlen(word); i < n; i++)
    {
        // Check the cases
        if (isalpha(word[i]))
        {
            char c = toupper(word[i]); // Convert to uppercase
            score += points[c - 'A'];  // Map A-Z to 0-25 using ASCII table, where A equals to 65
                                       // So if c = A, then 65 - 65 = 0
        }
    }

    return score;
}

int main(void)
{
    // Get words from both players
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Compute scores
    int score1 = compute_score(word1);
    int score2 = compute_score(word2);

    // Determine winner
    if (score1 > score2)
    {
        printf("Player 1 wins!\n");
    }
    else if (score2 > score1)
    {
        printf("Player 2 wins!\n");
    }
    else
    {
        printf("Tie!\n");
    }
}
