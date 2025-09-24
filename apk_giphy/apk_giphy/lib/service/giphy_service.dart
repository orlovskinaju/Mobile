
import 'dart:convert';

import 'package:http/http.dart' as http;

String _key = "Vx66OEkS0e0o4vPBCCS8TYDp9ECCFOiK";

class GiphyService {
  Future<Map> getGifs(String _search, int _offset) async{
    http.Response reresponse;
    if(_search == null || _search.isEmpty){
      reresponse = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=$_key&limit=25&offset=$_offset&rating=g&bundle=messaging_non_clips"));
    } else {
      reresponse = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=$_key&q=$_search&limit=25&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips"));
    }
    return json.decode(reresponse.body);
  }
}