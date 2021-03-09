// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedPosts _$RelatedPostsFromJson(Map<String, dynamic> json) {
  return RelatedPosts(
    id: json['id'] as int,
    url: json['url'] as String,
    img: json['img'] as String,
    date: json['date'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$RelatedPostsToJson(RelatedPosts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'img': instance.img,
      'date': instance.date,
      'title': instance.title,
    };

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  String content = json['content'] != null ? json['content']['rendered'] : "";
  String image = json['jetpack_featured_media_url'] != '' && json['jetpack_featured_media_url'] !=null
      ? json['jetpack_featured_media_url']
      : "https://images.wallpaperscraft.com/image/surface_dark_background_texture_50754_1920x1080.jpg";


  String date = DateFormat('dd MMMM, yyyy', 'en_US')
      .format(DateTime.parse(json["date"]))
      .toString();

  return PostModel(
    id: json['id'],
    title: json['title']['rendered'],
    content: content,
    excerpt: json['excerpt']['rendered'],
    jetpack_featured_media_url: image,
    categories: json['categories'],
    date: date,
    link: json['link'],
    jetpack_related_posts: (json['jetpack_related_posts'] as List)
        ?.map((e) =>
            e == null ? null : RelatedPosts.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'excerpt': instance.excerpt,
      'jetpack_featured_media_url': instance.jetpack_featured_media_url,
      'categories': instance.categories,
      'date': instance.date,
      'link': instance.link,
      'jetpack_related_posts': instance.jetpack_related_posts,
    };
