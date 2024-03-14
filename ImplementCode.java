package org.example;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ImplementCode {
    public static void main(String[] args) {

        try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))){
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
                    System.out.println("INvalid input");
                    return;
                }

            }
        } catch (IOException e) {
            e.fillInStackTrace();
        }
    }
}