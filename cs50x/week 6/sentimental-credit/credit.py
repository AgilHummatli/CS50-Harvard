from cs50 import get_string

# Get credit card number as a string
number = get_string("Number: ")

# Luhn’s Algorithm
total = 0
length = len(number)

for i in range(length):
    digit = int(number[length - 1 - i])

    if i % 2 == 1:
        digit *= 2
        if digit > 9:
            digit -= 9

    total += digit

# Check if valid according to Luhn
if total % 10 != 0:
    print("INVALID")

else:
    # AMEX: 15 digits, starts with 34 or 37
    if length == 15 and (number.startswith("34") or number.startswith("37")):
        print("AMEX")

    # MASTERCARD: 16 digits, starts with 51–55
    elif length == 16 and number[:2] in ["51", "52", "53", "54", "55"]:
        print("MASTERCARD")

    # VISA: 13 or 16 digits, starts with 4
    elif (length == 13 or length == 16) and number.startswith("4"):
        print("VISA")

    else:
        print("INVALID")
