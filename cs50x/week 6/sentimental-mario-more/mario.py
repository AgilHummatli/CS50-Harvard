from cs50 import get_int

# Keep asking until height is valid
while True:
    height = get_int("Height: ")
    if 1 <= height <= 8:
        break

# Build the pyramids
for i in range(1, height + 1):
    spaces = height - i
    hashes = i

    # Left pyramid + gap + right pyramid
    print(" " * spaces + "#" * hashes + "  " + "#" * hashes)
