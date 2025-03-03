import 'dart:ui';
import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  final String workName;
  final String numberWorker;
  final String imageUrl;


  const WorkerCard({
    Key? key,
    required this.workName,
    required this.imageUrl,
    required this.numberWorker
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 137,
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 5,
            left: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 65,
                  width: 102,
                  color: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height:15),
                      Text(
                        workName,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight:FontWeight.bold,
                          fontSize: 14, // Adjust font size as needed
                          color: Colors.black, // Adjust color if needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        numberWorker+"worker",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      /*SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: workerImages
                              .asMap()
                              .entries
                              .map(
                                (entry) => Transform.translate(
                              offset: Offset(-entry.key * 10.0, 0), // Overlapping effect
                              child: CircleAvatar(
                                radius: 11, // Adjust size for intertwining
                                backgroundImage: AssetImage(entry.value),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),*/
                    ],
                  ),

                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
