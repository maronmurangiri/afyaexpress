import 'package:afyaexpress/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String specialization;
  //final double rating;
  //final int reviews;

  const DoctorCard({
    Key? key,
    required this.doctorName,
    required this.specialization,
    //required this.rating,
    //required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.34,
                child: Image.asset(
                  'images/doc.png',
                  fit: BoxFit.fill,
                ), // will be changed before full implementation
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        specialization,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.star_border,
                              color: Colors.yellow, size: 16),
                          const Spacer(flex: 1),
                          Text('4.5'),
                          const Spacer(flex: 1),
                          const Text('Reviews'),
                          const Spacer(flex: 1),
                          Text('20'),
                          const Spacer(flex: 7),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {}, //will redirect to doctor details
      ),
    );
  }
}
