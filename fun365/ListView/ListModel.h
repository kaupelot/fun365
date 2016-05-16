//
//  ListModel.h
//  fun365
//
//  Created by walt zeng on 15/6/8.
//  Copyright (c) 2015年 曾旺. All rights reserved.
//

#import <Foundation/Foundation.h>

#define eassays @[@"fdc70b1674c64b16a8bde8198d16c726_1",@"a06e2ebc-accd-4bc7-9311-613c7adf5a17_1",@"d1b01607-873f-400e-bd2f-332e5b9ce7f6_1",@"9f1cfa88-1d49-414d-b455-4f95173b1a56_1",@"4f5a53e3-753a-4634-8a09-39ab32d1eb8c_1",@"75c907cf2dfb48d2b10307f947034a3f_1",@"b8c788f69cf64ff5b9f05dfa711d95c7_1",@"8b28a90a108d482ba5e7adcd92829f00_1",@"0e7e9a77-c7e0-426c-a4a2-f731bdf9c6a8_1",@"e9d2582740e0450d9f6d950df85c51fb_1",@"e31932ce34ee4479848a924bd0113a87_1"];
#define eassaysTitle @[@"连岳",@"煎蛋",@"喷嚏网",@"知乎每日精选",@"狂囧网",@"涨姿势",@"历史控",@"知道日报",@"热文排行榜",@"百度百科—精彩专题",@"网易热门跟贴"];
#define news @[@"8e1d712a40d74cb2a0ecd7e2167aefd4_1",@"46e618fd-2681-4a02-935f-8473a875fdce_1",@"3a4d6ba4-2e3f-4347-840b-32832abb7687_1",@"5693f641-b759-4488-b3c0-3fc3cca5c351_1",@"c64e7f97-c947-4732-8586-ecf8cb48cc51_1",@"95cdf20cb47b4cb2b7809520f60758ea_1",@"b78dc3ae8bf547eba0a02a475b19c590_1",@"0bd8eb284999412aba0580c623a7e564_1",@"5c5a71bf-cd3d-451c-87ba-319702d06bcf_1",@"9fafe05ad613469499df1319cba6f57b_1",@"382d78f7b9594b7f8560d155de4f7581_1",@"d88457660d7b407094d55b033a2c2063_1"];
#define newsTitle @[@"新闻滑翔",@"网易新闻",@"南方都市报",@"新京报",@"体坛周报",@"易百科",@"每日外媒精选",@"今日之声",@"中国新闻网",@"GEO视界",@"壹读",@"自媒体精选"];
#define jokes @[@"1a5a1958c6a94d549736d35fec1292c9_1",@"3b3fd7e9-f2cb-4145-9387-eeb7affff9ac_1",@"09246944-fb72-4a25-8496-d5b5c441f103_1",@"c67e4e0e-299c-4c43-ab28-6d6c7b181bd3_1",@"3e279c07f300497fa98685ae3ad445a7_1",@"345ea9b9-fdb8-4bc7-8f2b-72680f4a827a_1",@"3367415c-7b9f-4874-ac4b-dc75390634f1_1",@"df7dfc75-8a8f-4410-bb18-fe6456f0fb49_1",@"8aacbac7e3ff4471a9e2a6017e3400f9_1"];
#define jokesTitle @[@"节操精选",@"如厕",@"我们爱讲冷笑话",@"挖段子冷笑话",@"凯迪每日精选",@"微博段子",@"笑话幽默",@"笑话精选",@"爆笑gif图"];
#define pictures @[@"2588b3b6-5dc2-46ef-8e3b-fcce69133b18_1",@"16f9a42d-7385-4ea4-b3ac-05041fe40ffc_1",@"994f3724-da93-407d-84c2-46e6074648ed_1",@"dcbb16cfab3a49a78fb4e0c59730cee8_1",@"ba8408d6-78e7-4a94-93e6-45705030dc50_1",@"280311595f924cf8bd35a20cfaeb9851_1",@"4edbd81c2e04485b8aef0e316fbb5e59_1",@"6722b417186349be9ba10c28858768c1_1",@"e1a93e513fc54900a865a6cb5731bcda_1"];
#define picturesTitle @[@"图片精选",@"每日一图精选",@"图虫网",@"没品图",@"一图一世界",@"十张内涵图",@"九妖内涵图",@"叽歪笑话-恶搞囧图",@"图展网美女"];
#define originUrl @"http://yuedu.163.com/source.do?operation=queryContentList&id="
#define contentUrl @"http://yuedu.163.com/source.do?operation=queryContentHtml&id="
#define public @"蛮有味是一款轻量的阅读app,我们集合了段子,趣图,新闻,文章等一些富有影响力的阅读资源.通过特色的摇一摇功能,您可以随心切换您想不到的阅读资源.随时收藏可以随时阅读,流量不足时我们为您开启无图模式.<br/>技术支持:@XDD233,@艺成行天涯,@aimon,<br/>反馈: <a href=mailto:13601047527@163.com>13601047527@163.com</a>"
#define download @"https://itunes.apple.com/cn/app/100859925"
#define checkversion @"https://itunes.apple.com/lookup?id=100859925"

#define avosID @"5o8la9hmmib4yz74wq8qi6m7w3a3udfkh9358zsip8ul8e3j"
#define avosKey @"renjt37gxx9t2pg8vfrd7zhkcuk3cptt0pv43t0s0w3o1916"
#define shareID @"7f09e39d6c20"
#define weiboID @"717202405"
#define weiboKey @"25f62e40094b5fe6ea506d053b6959a4"
#define qZoneID @"1104654545"
#define qZoneKey @"fI9XNYVYSnatxGBV"
#define qqID @"QQ41D7B0D1"
#define weixinID @"wx4fc9d32e049b7595"
#define weixinKey @"5112892cb539cba987598f33db0491b1"

#define newsONE @"46e618fd-2681-4a02-935f-8473a875fdce_1"
#define eassayONE @"a06e2ebc-accd-4bc7-9311-613c7adf5a17_1"
#define jokesONE @"09246944-fb72-4a25-8496-d5b5c441f103_1"
#define pictureONE @"16f9a42d-7385-4ea4-b3ac-05041fe40ffc_1"

#define versionNOW @"1.1"

@interface ListModel : NSObject

@property (nonatomic,copy)NSString *posttime;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSArray *images;
@property(nonatomic,strong)NSString *summaryImageURL;
@property(nonatomic,assign)NSInteger summaryImageHeight;
@property(nonatomic,assign)NSInteger summaryImageWidth;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *sourceUrl;
@property (nonatomic,strong)NSString *breif;
@property (nonatomic,strong)NSString *source;

@property (nonatomic,strong)NSString *sourceID;
@property (nonatomic,strong)NSString *contentID;
@property (nonatomic,strong)NSData *htmldata;

@end
