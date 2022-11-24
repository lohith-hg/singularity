import 'package:singularity/data/mars_pictures.dart';
import 'package:singularity/data/picture_of_the_day.dart';
import 'package:http/http.dart' as http;

class LocalService {
  Future<List<PictureOfTheDay>?> getPictures(DateTime startDay, int days) async {
    var lastDate = startDay.subtract(Duration(days: days));
    var oldDate = "${lastDate.year}-${lastDate.month}-${lastDate.day}";
    var latestDate =
        "${startDay.subtract(const Duration(hours: 9)).year}-${startDay.subtract(const Duration(hours: 9)).month}-${startDay.subtract(const Duration(hours: 9)).day}";

    var client = http.Client();
    var uri = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW&start_date=$oldDate&end_date=$latestDate');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return pictureOfTheDayFromJson(json);
    }
  }

  Future<MarsPictures?> getMarsPictures() async {
    var latestDate =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    var client = http.Client();
    var uri = Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=$latestDate&api_key=Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return marsPicturesFromJson(json);
    }
  }
}
