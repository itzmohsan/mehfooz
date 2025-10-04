import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mehfooz/core/constants/app_constants.dart';
import 'package:mehfooz/core/constants/colors.dart';
import 'package:mehfooz/core/security/auth_service.dart';
import 'package:mehfooz/core/services/secure_storage_service.dart';
import 'package:mehfooz/models/document.dart';

class DigitalLockerPage extends StatefulWidget {
  const DigitalLockerPage({super.key});

  @override
  State<DigitalLockerPage> createState() => _DigitalLockerPageState();
}

class _DigitalLockerPageState extends State<DigitalLockerPage> {
  final SecureStorageService _storage = SecureStorageService();
  final AuthService _auth = AuthService();
  final ImagePicker _picker = ImagePicker();
  
  List<Document> _documents = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Identity', 'Financial', 'Property', 'Education', 'Medical', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    
    try {
      final pin = await _getUserPin();
      final documentsData = await _storage.getAllDocuments(pin);
      
      _documents = documentsData.map((data) => Document.fromJson(data)).toList();
    } catch (e) {
      print('Error loading documents: ');
      _documents = [];
    }
    
    setState(() => _isLoading = false);
  }

  Future<String> _getUserPin() async {
    return '0000'; // In production, get from secure storage
  }

  Future<void> _addDocument() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _DocumentSourceSheet(),
    );

    if (source == null) return;

    try {
      Map<String, dynamic>? docData;
      
      if (source == 'camera') {
        docData = await _takePhoto();
      } else if (source == 'gallery') {
        docData = await _pickFromGallery();
      } else if (source == 'text') {
        docData = await _createTextDocument();
      }

      if (docData != null) {
        await _processNewDocument(docData);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: '),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    final file = File(image.path);
    final stat = await file.stat();
    
    return {
      'name': 'Photo_' + DateTime.now().millisecondsSinceEpoch.toString(),
      'fileType': 'image',
      'fileSize': stat.size,
      'category': 'Identity',
    };
  }

  Future<Map<String, dynamic>?> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final file = File(image.path);
    final stat = await file.stat();
    
    return {
      'name': 'Image_' + DateTime.now().millisecondsSinceEpoch.toString(),
      'fileType': 'image',
      'fileSize': stat.size,
      'category': 'Identity',
    };
  }

  Future<Map<String, dynamic>?> _createTextDocument() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _DocumentNameDialog(),
    );

    if (name == null || name.isEmpty) return null;
    
    return {
      'name': name,
      'fileType': 'text',
      'fileSize': 1024,
      'category': 'Other',
    };
  }

  Future<void> _processNewDocument(Map<String, dynamic> docData) async {
    try {
      final pin = await _getUserPin();
      final document = Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: docData['name'] ?? 'Untitled',
        category: docData['category'] ?? 'Other',
        createdAt: DateTime.now(),
        fileType: docData['fileType'] ?? 'image',
        fileSize: docData['fileSize'] ?? 0,
      );

      await _storage.storeDocument(document.id, document.toJson(), pin);
      await _loadDocuments();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document added securely'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add document'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _viewDocument(Document document) {
    showDialog(
      context: context,
      builder: (context) => _DocumentViewDialog(document: document),
    );
  }

  Future<void> _deleteDocument(String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.deleteDocument(docId);
      await _loadDocuments();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document deleted'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  List<Document> get _filteredDocuments {
    if (_selectedCategory == 'All') return _documents;
    return _documents.where((doc) => doc.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Digital Locker'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                );
              },
            ),
          ),

          // Documents List
          Expanded(
            child: _isLoading ? _buildLoadingState() : 
                   _filteredDocuments.isEmpty ? _buildEmptyState() : 
                   _buildDocumentsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDocument,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading secure documents...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 80, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text(
            'No documents yet',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first secure document',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final document = _filteredDocuments[index];
        return _DocumentCard(
          document: document,
          onTap: () => _viewDocument(document),
          onDelete: () => _deleteDocument(document.id),
        );
      },
    );
  }
}

class _DocumentSourceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt_rounded, color: AppColors.primary),
            title: Text('Take Photo'),
            onTap: () => Navigator.pop(context, 'camera'),
          ),
          ListTile(
            leading: Icon(Icons.photo_library_rounded, color: AppColors.primary),
            title: Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context, 'gallery'),
          ),
          ListTile(
            leading: Icon(Icons.text_snippet_rounded, color: AppColors.primary),
            title: Text('Create Text Document'),
            onTap: () => Navigator.pop(context, 'text'),
          ),
        ],
      ),
    );
  }
}

class _DocumentNameDialog extends StatefulWidget {
  @override
  State<_DocumentNameDialog> createState() => _DocumentNameDialogState();
}

class _DocumentNameDialogState extends State<_DocumentNameDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Document Name'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter document name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text('CREATE'),
        ),
      ],
    );
  }
}

class _DocumentViewDialog extends StatelessWidget {
  final Document document;

  const _DocumentViewDialog({required this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(document.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(Icons.description_rounded, size: 60, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16),
          _DetailRow(title: 'Category', value: document.category),
          _DetailRow(title: 'Type', value: document.fileType.toUpperCase()),
          _DetailRow(title: 'Size', value: document.formattedSize),
          _DetailRow(title: 'Added', value: document.formattedDate),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_rounded, color: AppColors.success, size: 16),
                SizedBox(width: 8),
                Text(
                  'Encrypted and Secure',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CLOSE'),
        ),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Share functionality - Coming in production'),
                backgroundColor: AppColors.info,
              ),
            );
          },
          child: Text('SHARE SAFELY'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title + ':',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.description_rounded,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          document.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          document.category + '  ' + document.formattedDate,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert_rounded),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('View Details'),
              onTap: onTap,
            ),
            PopupMenuItem(
              child: Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
