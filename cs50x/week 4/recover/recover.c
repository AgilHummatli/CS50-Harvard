#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef uint8_t BYTE;

int main(int argc, char *argv[])
{
    // Ensure proper usage
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }

    // Open memory card
    FILE *card = fopen(argv[1], "r");
    if (card == NULL)
    {
        printf("Could not open %s.\n", argv[1]);
        return 1;
    }

    BYTE buffer[512]; // 512-byte block
    FILE *img = NULL; // Current JPEG file
    int count = 0;    // JPEG counter
    char filename[8]; // "###.jpg" + null terminator

    // Read 512-byte blocks until end of file
    while (fread(buffer, 1, 512, card) == 512)
    {
        // Check if block is start of a new JPEG
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff &&
            (buffer[3] & 0xf0) == 0xe0)
        {
            // Close previous JPEG, if any
            if (img != NULL)
            {
                fclose(img);
            }

            // Create new filename
            sprintf(filename, "%03i.jpg", count);
            img = fopen(filename, "w");
            if (img == NULL)
            {
                printf("Could not create %s.\n", filename);
                fclose(card);
                return 1;
            }

            count++;
        }

        // If a JPEG file is open, write the block
        if (img != NULL)
        {
            fwrite(buffer, 1, 512, img);
        }
    }

    // Close any remaining file
    if (img != NULL)
    {
        fclose(img);
    }

    fclose(card);
    return 0;
}
