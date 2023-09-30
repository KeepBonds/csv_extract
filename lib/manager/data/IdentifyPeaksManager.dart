import 'dart:math';

class IdentifyPeaksManager {

  static void identify(List<double> data) {
    // Calculate the mean (average) of the data
    final mean = data.fold<double>(0, (prev, element) => prev + element) / data.length;

    final spikeThreshold = 2.0;
    // Identify spikes in the data
    final spikes = findSpikes(data, spikeThreshold);

    // Print the mean and identified spikes
    print('Mean: $mean');
    print('Spikes: $spikes');
  }


  static List<double> findSpikes(List<double> data, double threshold) {
    final List<double> spikes = [];

    for (int i = 1; i < data.length - 1; i++) {
      final double prev = data[i - 1];
      final double current = data[i];
      final double next = data[i + 1];

      if (current - prev > threshold && current - next > threshold) {
        spikes.add(current);
      }
    }

    return spikes;
  }

  List<double> findHumps(List<double> data) {
    final List<double> humps = [];

    for (int i = 1; i < data.length - 1; i++) {
      final double prev = data[i - 1];
      final double current = data[i];
      final double next = data[i + 1];

      if (current > prev && current > next) {
        humps.add(current);
      }
    }

    return humps;
  }

  static double calculateStandardDeviation(List<double> data) {
    // Step 1: Calculate the mean (average) of the data
    double sum = 0;
    for (var value in data) {
      sum += value;
    }
    double mean = sum / data.length;

    // Step 2: Calculate the squared differences from the mean
    List<double> squaredDifferences = [];
    for (var value in data) {
      double difference = value - mean;
      double squaredDifference = difference * difference;
      squaredDifferences.add(squaredDifference);
    }

    // Step 3: Calculate the variance (mean of squared differences)
    double variance = squaredDifferences.reduce((a, b) => a + b) / data.length;

    // Step 4: Calculate the standard deviation (square root of variance)
    double standardDeviation = sqrt(variance);

    double MOE = calculateMarginOfError(standardDeviation, data.length, 95.0);
    print("MOE: " + MOE.toString());

    return standardDeviation;
  }

  static double calculateMarginOfError(double populationStandardDeviation, int sampleSize, double confidenceLevel) {
    // Z-score for the given confidence level
    double zScore;

    switch (confidenceLevel) {
      case 90.0:
        zScore = 1.645; // For 90% confidence level
        break;
      case 95.0:
        zScore = 1.960; // For 95% confidence level
        break;
      case 99.0:
        zScore = 2.576; // For 99% confidence level
        break;
      default:
        throw ArgumentError('Unsupported confidence level. Use 90.0, 95.0, or 99.0.');
    }

    // Calculate the margin of error
    double marginOfError = zScore * (populationStandardDeviation / sqrt(sampleSize));

    return marginOfError;
  }
}