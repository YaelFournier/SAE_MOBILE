import 'package:flutter/material.dart';

class AccueilView extends StatelessWidget {
  const AccueilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre
            const Text(
              "Restaurants à la Une",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Espacement entre le titre et les images

            // Grille des images
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2, // 2 colonnes
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children:
                List.generate(4, (index) {
                  String image = "images/image${index + 1}.jpg";
                  return GestureDetector(
                    onTap: () {
                      // Action quand on clique sur une image
                      print("Image ${index + 1} cliquée !");
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
            ),
          ],
        ),
      ),
    );
  }
}