from cs50 import get_string


def main():
    # Get user input
    text = get_string("Text: ")

    # Initialize counters
    letters = 0
    words = 0
    sentences = 0

    # Iterate through the text to count components
    for char in text:
        # Count letters (A-Z or a-z)
        if char.isalpha():
            letters += 1

        # Count sentence endings (. ! ?)
        elif char in ['.', '!', '?']:
            sentences += 1

    # Count words (assuming words are separated by spaces)
    # split() handles multiple spaces and leading/trailing whitespace effectively
    words = len(text.split())

    # Coleman-Liau formula logic
    # L is average letters per 100 words
    # S is average sentences per 100 words
    L = (letters / words) * 100
    S = (sentences / words) * 100

    # Calculate index
    index = 0.0588 * L - 0.296 * S - 15.8

    # Round to nearest integer
    grade = round(index)

    # Output results based on grade thresholds
    if grade >= 16:
        print("Grade 16+")
    elif grade < 1:
        print("Before Grade 1")
    else:
        print(f"Grade {grade}")


if __name__ == "__main__":
    main()
