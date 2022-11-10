import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_quotes_app/utils/capture_screenshot.dart';
import '../global.dart';
import '../helpers/quotes_db.dart';
import '../modals/quot.dart';
import '../utils/copy_quote_in_clipboard.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          Global.tableName,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: DBHelper.dbHelper.fetchAllRecords(tableName: Global.tableName),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            List<QuotDB>? res = snapShot.data;

            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: res!.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.all(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Global.selectedQuote = res[i];
                        Navigator.of(context).pushNamed("details_page");
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          height: 420,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.6),
                                          BlendMode.hardLight,
                                        ),
                                        fit: BoxFit.cover,
                                        image: MemoryImage(
                                          res[i].image,
                                        ),
                                      ),
                                    ),
                                    height: 350,
                                    width: double.infinity,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      res[i].quot,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.image,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        copyQuoteInClipBoard(
                                          context: context,
                                          res: res[i],
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.copy_rounded,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        captureScreenShort(
                                          context: context,
                                          res: res[i],
                                          isShare: true,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        captureScreenShort(
                                          context: context,
                                          res: res[i],
                                          isShare: false,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.download,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.star_border,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
