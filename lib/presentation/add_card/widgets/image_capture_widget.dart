import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImageCaptureWidget extends StatelessWidget {
  final String? frontImagePath;
  final String? backImagePath;
  final Function(String, bool) onImageCaptured;

  const ImageCaptureWidget({
    Key? key,
    required this.frontImagePath,
    required this.backImagePath,
    required this.onImageCaptured,
  }) : super(key: key);

  void _showImageSourceDialog(BuildContext context, bool isFront) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Select Image Source',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),

              // Camera Option
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Camera',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Take a photo of your card',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _captureFromCamera(context, isFront);
                },
              ),

              // Gallery Option
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Gallery',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Choose from your photos',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _selectFromGallery(context, isFront);
                },
              ),

              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _captureFromCamera(BuildContext context, bool isFront) {
    // Simulate camera capture
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock image path - in real implementation, this would be from image_picker
      String mockImagePath = isFront
          ? 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=250&fit=crop'
          : 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=250&fit=crop';
      onImageCaptured(mockImagePath, isFront);
    });
  }

  void _selectFromGallery(BuildContext context, bool isFront) {
    // Simulate gallery selection
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock image path - in real implementation, this would be from image_picker
      String mockImagePath = isFront
          ? 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=250&fit=crop'
          : 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=250&fit=crop';
      onImageCaptured(mockImagePath, isFront);
    });
  }

  void _removeImage(bool isFront) {
    onImageCaptured('', isFront);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Images',
          style: AppTheme.lightTheme.textTheme.headlineSmall,
        ),
        SizedBox(height: 2.h),

        Text(
          'Capture or upload images of your card for easy identification',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),

        // Front Image Section
        _buildImageSection(
          context: context,
          title: 'Card Front',
          subtitle: 'Capture the front side of your card',
          imagePath: frontImagePath,
          isFront: true,
          icon: 'credit_card',
        ),

        SizedBox(height: 4.h),

        // Back Image Section
        _buildImageSection(
          context: context,
          title: 'Card Back',
          subtitle: 'Capture the back side of your card',
          imagePath: backImagePath,
          isFront: false,
          icon: 'flip_to_back',
        ),

        SizedBox(height: 4.h),

        // Security Notice
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Notice',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Images are stored locally on your device and are encrypted for security. They are never uploaded to any server.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String? imagePath,
    required bool isFront,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: imagePath != null && imagePath.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: imagePath,
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _showImageSourceDialog(context, isFront),
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _removeImage(isFront),
                              icon: CustomIconWidget(
                                iconName: 'delete',
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () => _showImageSourceDialog(context, isFront),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CustomIconWidget(
                          iconName: icon,
                          color: AppTheme.lightTheme.primaryColor,
                          size: 32,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Tap to add image',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Camera or Gallery',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
