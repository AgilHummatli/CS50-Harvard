#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>

int main(void)
{
    // Get input text
    string text = get_string("Text: ");

    int letters = 0;
    int words = 0;
    int sentences = 0;

    // Loop through each character
    for (int i = 0; text[i] != '\0'; i++)
    {
        // Count letters with cases
        if (isalpha(text[i]))
        {
            letters++;
        }

        // Count words with hitting spaces
        if (text[i] == ' ')
        {
            words++;
        }

        // Count sentences with hitting punctuation marks
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sentences++;
        }
    }

    // Last word with no space after it
    words++;

    // Calculate averages per 100 words
    float L = ((float) letters / words) * 100;
    float S = ((float) sentences / words) * 100;

    // Coleman-Liau index
    float index = 0.0588 * L - 0.296 * S - 15.8;

    // Rounding the result
    int grade = round(index);

    // Output result
    if (grade < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (grade >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %i\n", grade);
    }
}
