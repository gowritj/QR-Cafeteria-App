import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:module/Staff/staff_main_page.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  // 📸 PICK IMAGE
  Future<void> pickImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      debugPrint("Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image")),
      );
    }
  }

  // 💾 SAVE PRODUCT
  Future<void> saveProduct() async {
  if (nameController.text.isEmpty ||
      priceController.text.isEmpty ||
      categoryController.text.isEmpty ||
      selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fill all fields")),
    );
    return;
  }

  try {
   
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploading product...")),
    );

    
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child("products")
        .child("$fileName.jpg");

    await ref.putFile(selectedImage!);

    final imageUrl = await ref.getDownloadURL();
  await FirebaseFirestore.instance.collection("products").add({
  "name": nameController.text,
  "price": int.parse(priceController.text),
  "category": categoryController.text,
  "imageUrl": imageUrl,
  "description": "New item",
  "createdAt": Timestamp.now(),
});

    
    
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product uploaded successfully")),
    );

    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StaffPage()),
      (route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // 🖼 IMAGE PICKER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 40),
                          SizedBox(height: 8),
                          Text("Tap to upload image"),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category (Biryani, Pizza...)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: saveProduct,
                child: const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
