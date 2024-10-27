class ResponseResult {
  final int score;
  final String description;
  final String status;
  final List<BreakdownItem> breakdown;

  ResponseResult({
    required this.score,
    required this.description,
    required this.status,
    required this.breakdown,
  });

  factory ResponseResult.fromResponse(String response) {
    int score = 0;
    String description = 'Description not available';
    String status = 'Unknown';
    List<BreakdownItem> breakdown = [];

    // Extract score
    final scoreMatch = RegExp(r'Results:\s*(\d+)\s*out of 100').firstMatch(response);
    if (scoreMatch != null) {
      score = int.parse(scoreMatch.group(1)!);
    }

    // Extract overall description
    final overallDescriptionMatch = RegExp(
      r'Overall Description:\s*(.*?)\s*(?=\n\nResult Breakdown)',
      dotAll: true,
    ).firstMatch(response);
    if (overallDescriptionMatch != null) {
      description = overallDescriptionMatch.group(1)!.trim();
    }

    // Extract detailed breakdown
    final breakdownMatches = RegExp(
      r'\*\s\*\*(.+?):\s*(\d+|N/A)\s*\n\s+Description:\s*(.*?)(?=\n\n|\*\s\*\*|$)',
      dotAll: true,
    ).allMatches(response);

    for (final match in breakdownMatches) {
      final title = match.group(1)!.trim();
      final scoreString = match.group(2)!.trim();
      final details = match.group(3)!.trim();

      breakdown.add(BreakdownItem(
        title: title,
        score: scoreString == 'N/A' ? null : int.tryParse(scoreString),
        details: details,
      ));
    }

    // Determine status based on score
    if (score >= 80) {
      status = 'Good';
    } else if (score >= 50) {
      status = 'Fair';
    } else {
      status = 'Poor';
    }

    return ResponseResult(
      score: score,
      description: description,
      status: status,
      breakdown: breakdown,
    );
  }
}

class BreakdownItem {
  final String title;
  final int? score; // Allow null for "N/A" cases
  final String details;

  BreakdownItem({
    required this.title,
    required this.score,
    required this.details,
  });
}
