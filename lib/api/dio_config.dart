import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  final String _baseUrl = 'https://dgnc-mini-cms.hcdc.vn/api';

  ApiService() {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers = {
      'Accept': '*/*',
      'Accept-Language': 'en-US,en;q=0.7',
      'Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Origin': 'https://dgnc.hcdc.vn',
      'Referer': 'https://dgnc.hcdc.vn/',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'same-site',
      'Sec-GPC': '1',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
      'sec-ch-ua': '"Brave";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
    };
  }
}
