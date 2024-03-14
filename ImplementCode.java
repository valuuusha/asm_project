package org.example;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ImplementCode {

    public static String toBinary(int num) {
        if (num == 0) return "0";

        StringBuilder binary = new StringBuilder();
        boolean isNegative = false;

        if (num < 0) {
            isNegative = true;
            num = -num;
        }

        while (num > 0) {
            binary.insert(0, num % 2);
            num /= 2;
        }

        if (isNegative) {
            while (binary.length() < 32) {
                binary.insert(0, '0');
            }
        }

        return binary.toString();
    }


    public static void main(String[] args) {
        try (BufferedReader reader = new BufferedReader(new FileReader("C:\\Users\\Vale\\AppData\\Roaming\\JetBrains\\IdeaIC2023.2\\scratches\\file.txt"))){
            String line;
            int totalNumbers = 0; // Лічильник загальної кількості чисел

            while ((line = reader.readLine()) != null) {
                if (line.length() > 255) {
                    System.out.println("Invalid input");
                    return;
                }
                String[] numbers = line.trim().split("\\s+");
                totalNumbers += numbers.length;

                if (totalNumbers > 10000) {
                    System.out.println("Invalid input");
                    return;
                }

                for (String numberStr : numbers) {
                    int number = Integer.parseInt(numberStr);
                    toBinary(number);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}