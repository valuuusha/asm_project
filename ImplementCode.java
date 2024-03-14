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
    public static void bubbleSort(String[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j].compareTo(arr[j + 1]) > 0) {
                    String temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
    public static double median(String[] binaryNumbers) {
        double median;
        int middle = binaryNumbers.length / 2;
        if (binaryNumbers.length % 2 == 0) {
            median = (Integer.parseInt(binaryNumbers[middle - 1], 2) + Integer.parseInt(binaryNumbers[middle], 2)) / 2.0;
        } else {
            median = Integer.parseInt(binaryNumbers[middle], 2);
        }
        return median;
    }

    public static double average(String[] binaryNumbers) {
        double sum = 0;
        for (String binaryNumber : binaryNumbers) {
            sum += Integer.parseInt(binaryNumber, 2);
        }
        return sum / binaryNumbers.length;
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

                String[] binaryNumbers = new String[numbers.length];

                for (int i = 0; i < numbers.length; i++) {
                    int number = Integer.parseInt(numbers[i]);
                    binaryNumbers[i] = toBinary(number);
                }

                bubbleSort(binaryNumbers);


                System.out.println(Math.round(median(binaryNumbers)) + " " + Math.round(average(binaryNumbers)));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}