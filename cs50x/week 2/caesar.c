#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to check if a string is a valid positive integer
bool is_valid_key(string s)
{
    for (int i = 0, n = strlen(s); i < n; i++)
    {
        if (!isdigit(s[i]))
        {
            return false; // found a non-digit
        }
    }
    return true; // all characters are digits
}

int main(int argc, string argv[])
{
    // Check for exactly one command-line argument, the key for shifting
    if (argc != 2 || !is_valid_key(argv[1]))
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    // Convert key from string to integer with atoi function
    int key = atoi(argv[1]);

    // Key must not be negative (extra safety, though is_valid_key ensures digits)
    if (key < 0)
    {
        printf("Key must be a non-negative integer.\n");
        return 1;
    }

    // Get text from user
    string plaintext = get_string("plaintext: ");

    printf("ciphertext: ");

    // Loop through each character
    for (int i = 0, n = strlen(plaintext); i < n; i++)
    {
        char c = plaintext[i];

        // Encrypt uppercase letters
        if (isupper(c))
        {
            // shift letter by key, wrap around using modulo 26 with ASCII table
            // modulo 26 is wrapping around the alphabet
            printf("%c", ((c - 'A' + key) % 26) + 'A');
        }
        // Encrypt lowercase letters
        else if (islower(c))
        {
            printf("%c", ((c - 'a' + key) % 26) + 'a');
        }
        // Non-letter characters remain unchanged
        else
        {
            printf("%c", c);
        }
    }

    printf("\n");
    return 0;
}
