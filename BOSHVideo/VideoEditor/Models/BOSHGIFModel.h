//
//  BOSHGIFModel.h
//  BOSHVideo
//
//  Created by yang on 2017/11/29.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"


//{
//type: "gif",
//    id: "26uf6ndZkV5rg1ea4",
//slug: "sephora-beauty-makeup-cosmetics-26uf6ndZkV5rg1ea4",
//url: "https://giphy.com/gifs/sephora-beauty-makeup-cosmetics-26uf6ndZkV5rg1ea4",
//bitly_gif_url: "https://gph.is/2bf9a8g",
//bitly_url: "https://gph.is/2bf9a8g",
//embed_url: "https://giphy.com/embed/26uf6ndZkV5rg1ea4",
//username: "sephora",
//source: "https://www.youtube.com/watch?v=niQ0tMZgjvY",
//rating: "g",
//content_url: "",
//source_tld: "www.youtube.com",
//source_post_url: "https://www.youtube.com/watch?v=niQ0tMZgjvY",
//is_indexable: 0,
//import_datetime: "2016-08-17 20:43:39",
//trending_datetime: "0000-00-00 00:00:00",
//user: {
//avatar_url: "https://media.giphy.com/avatars/default3.gif",
//banner_url: "",
//profile_url: "https://giphy.com/sephora/",
//username: "sephora",
//display_name: "Sephora",
//twitter: "",
//is_verified: true
//},
//images: {
//fixed_height_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200_s.gif",
//width: "358",
//height: "200"
//},
//original_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy_s.gif",
//width: "480",
//height: "268"
//},
//fixed_width: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w.gif",
//width: "200",
//height: "112",
//size: "377142",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w.mp4",
//mp4_size: "20273",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w.webp",
//webp_size: "116326"
//},
//fixed_height_small_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100_s.gif",
//width: "179",
//height: "100"
//},
//fixed_height_downsampled: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200_d.gif",
//width: "358",
//height: "200",
//size: "130539",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200_d.webp",
//webp_size: "30834"
//},
//preview: {
//width: "480",
//height: "268",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-preview.mp4",
//mp4_size: "35905"
//},
//fixed_height_small: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100.gif",
//width: "179",
//height: "100",
//size: "326472",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100.mp4",
//mp4_size: "18052",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100.webp",
//webp_size: "105776"
//},
//downsized_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-downsized_s.gif",
//width: "250",
//height: "139",
//size: "13696"
//},
//downsized: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-downsized.gif",
//width: "250",
//height: "139",
//size: "550743"
//},
//downsized_large: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.gif",
//width: "480",
//height: "268",
//size: "2144503"
//},
//fixed_width_small_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100w_s.gif",
//width: "100",
//height: "56"
//},
//preview_webp: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-preview.webp",
//width: "428",
//height: "239",
//size: "49036"
//},
//fixed_width_still: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w_s.gif",
//width: "200",
//height: "112"
//},
//fixed_width_small: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100w.gif",
//width: "100",
//height: "56",
//size: "130317",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100w.mp4",
//mp4_size: "10096",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/100w.webp",
//webp_size: "53732"
//},
//downsized_small: {
//width: "480",
//height: "268",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-downsized-small.mp4",
//mp4_size: "82448"
//},
//fixed_width_downsampled: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w_d.gif",
//width: "200",
//height: "112",
//size: "47165",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200w_d.webp",
//webp_size: "13670"
//},
//downsized_medium: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.gif",
//width: "480",
//height: "268",
//size: "2144503"
//},
//original: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.gif",
//width: "480",
//height: "268",
//size: "2144503",
//frames: "58",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.mp4",
//mp4_size: "74879",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.webp",
//webp_size: "407444"
//},
//fixed_height: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200.gif",
//width: "358",
//height: "200",
//size: "1055986",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200.mp4",
//mp4_size: "43301",
//webp: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/200.webp",
//webp_size: "246966"
//},
//looping: {
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-loop.mp4",
//mp4_size: "308887"
//},
//original_mp4: {
//width: "480",
//height: "268",
//mp4: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy.mp4",
//mp4_size: "74879"
//},
//preview_gif: {
//url: "https://media3.giphy.com/media/26uf6ndZkV5rg1ea4/giphy-preview.gif",
//width: "211",
//height: "118",
//size: "47768"
//},
//    480w_still: {
//    url: "https://media4.giphy.com/media/26uf6ndZkV5rg1ea4/480w_s.jpg",
//    width: "480",
//    height: "268"
//    }
//},
//title: "before and after wink GIF by Sephora"
//},


@interface BOSHGIFModel : NSObject

//height = 55;
//mp4 = "https://media0.giphy.com/media/ax30PHPpWix1e/100w.mp4";
//"mp4_size" = 8742;
//size = 235353;
//url = "https://media0.giphy.com/media/ax30PHPpWix1e/100w.gif";
//webp = "https://media0.giphy.com/media/ax30PHPpWix1e/100w.webp";
//"webp_size" = 156202;
//width = 100;

@property (nonatomic, copy) NSString *url;
@property (nonatomic) int height;
@property (nonatomic) int width;
@property (nonatomic) long size;


@property (nonatomic, copy) NSString *coverImage;
@property (nonatomic) int coverH;
@property (nonatomic) int coverW;

//"480w_still" =                 {
//    height = 266;
//    url = "https://media2.giphy.com/media/wZIQX9qYF4NOM/480w_s.jpg";
//    width = 480;
//};


@property (nonatomic, strong) NSURL *fileURL;
@end
