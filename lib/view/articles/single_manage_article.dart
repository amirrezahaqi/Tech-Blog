import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:tec/component/dimens.dart';
import 'package:tec/constant/my_colors.dart';
import 'package:tec/component/my_component.dart';
import 'package:tec/controller/article/manage_article_controller.dart';
import 'package:tec/controller/file_controller.dart';
import 'package:tec/controller/home_screen_controller.dart';
import 'package:tec/gen/assets.gen.dart';
import 'package:tec/services/pick_file.dart';
import 'article_content_editor.dart';

// ignore: must_be_immutable
class SingleManageArticle extends StatelessWidget {
  SingleManageArticle({Key? key}) : super(key: key);

  var manageArticleController = Get.find<ManageArticleController>();
  FilePickerController filePickerController = Get.put(FilePickerController());

  getTitle() {
    Get.defaultDialog(
        title: "عنوان مقاله",
        titleStyle: const TextStyle(color: SolidColors.scaffoldBg),
        content: TextField(
          controller: manageArticleController.titleTextEditingController,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: SolidColors.colorTitle),
          decoration: const InputDecoration(hintText: 'اینجا بنویس'),
        ),
        backgroundColor: SolidColors.primaryColor,
        radius: 8,
        confirm: ElevatedButton(
            onPressed: (() {
              manageArticleController.updateTitle();
              Get.back();
            }),
            child: const Text('ثبت')));
  }

  @override
  Widget build(BuildContext context) {
    var textheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Column(children: [
            Stack(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.height / 3,
                  child: filePickerController.file.value.name == 'nothing'
                      ? CachedNetworkImage(
                          imageUrl: manageArticleController
                              .articleInfoModel.value.image!,
                          imageBuilder: ((context, imageProvider) =>
                              Image(image: imageProvider)),
                          placeholder: ((context, url) => const Loading()),
                          errorWidget: ((context, url, error) => Image.asset(
                                Assets.images.singlePlaceHolder.path,
                                fit: BoxFit.cover,
                              )),
                        )
                      : Image.file(
                          File(filePickerController.file.value.path!),
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              end: Alignment.bottomCenter,
                              begin: Alignment.topCenter,
                              colors: GradientColors.singleAppbarGradiant)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          //pick file
                          await pickFile();
                        },
                        child: Container(
                          height: 30,
                          width: Get.width / 3,
                          decoration: const BoxDecoration(
                              color: SolidColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "انتخاب تصویر",
                                style: textheme.displayMedium,
                              ),
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            GestureDetector(
              onTap: () {
                getTitle();
              },
              child: SeeMoreBlog(
                bodyMargin: Dimens.halfBodyMargin,
                textTheme: textheme,
                title: 'ویرایش عنوان مقاله',
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Dimens.halfBodyMargin),
              child: Text(
                manageArticleController.articleInfoModel.value.title!,
                maxLines: 2,
                style: textheme.titleLarge,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => ArticleContentEditor()),
              child: SeeMoreBlog(
                bodyMargin: Dimens.halfBodyMargin,
                textTheme: textheme,
                title: 'ویرایش متن اصلی مقاله',
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                manageArticleController.articleInfoModel.value.content!,
                textStyle: textheme.headlineSmall,
                enableCaching: true,
                onLoadingBuilder: ((context, element, loadingProgress) =>
                    const Loading()),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                chooseCatsBottomSheet(textheme);
              },
              child: SeeMoreBlog(
                bodyMargin: Dimens.halfBodyMargin,
                textTheme: textheme,
                title: 'انتخاب دسته بندی ',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.halfBodyMargin),
              child: Text(
                manageArticleController.articleInfoModel.value.catName == null
                    ? "هیچ دسته بندی انتخاب نشده"
                    : manageArticleController.articleInfoModel.value.catName!,
                maxLines: 2,
                style: textheme.titleLarge,
              ),
            ),

            ElevatedButton(
                onPressed: (() async =>
                    await manageArticleController.storeArticle()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(manageArticleController.loading.value
                      ? "ٌصبر کنید ..."
                      : "ارسال مطلب"),
                ))
            // tags(textheme),
          ]),
        ),
      ),
    ));
  }

  Widget cats(textheme) {
    var homeScreenController = Get.find<HomeScreenController>();
    return SizedBox(
      height: Get.height / 1.7,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemCount: homeScreenController.tagsList.length,
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () async {
              manageArticleController.articleInfoModel.update((val) {
                val?.catId = homeScreenController.tagsList[index].id!;
                val?.catName = homeScreenController.tagsList[index].title!;
              });

              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: SolidColors.primaryColor),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Center(
                      child: Text(
                        homeScreenController.tagsList[index].title!,
                        style: textheme.headline2,
                      ),
                    )),
              ),
            ),
          );
        }),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
      ),
    );
  }


  chooseCatsBottomSheet(TextTheme textTheme){


   Get.bottomSheet(

      Container(
          height: Get.height/1.5,

          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: SingleChildScrollView(
              child: Column(children:   [
                const Text("انتخاب دسته بندی"),
                const SizedBox(height: 8,)
                ,cats(textTheme)
              ]),
            ),
          ),
        ),
        isScrollControlled: true,
        persistent: true
    );


  }
}
