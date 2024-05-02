import "package:file_picker/file_picker.dart";

class PickFilesFromLocal {
  Future<String?> pickImage() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null) return null;
    return result.files[0].path;
  }
}
