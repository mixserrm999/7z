

#import "vm_writeData.h"
#import "Esp/ImGuiDrawView.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include "ImGuiMemory/imgui.h"
#include "ImGuiMemory/imgui_impl_metal.h"
#import <Foundation/Foundation.h>
#import "Esp/CaptainHook.h"
#include "Esp/ESP.h"

#include "font.h" 
#include "Semi-Bold.h"

#include "Settings.h"
#include "imguipp.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale
#define kTest   0 
#define g 0.86602540378444 

@interface ImGuiDrawView () <MTKViewDelegate>
//@property (nonatomic, strong) IBOutlet MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;






@property (nonatomic,  strong) UILabel *numberLabel;


@property (nonatomic,  strong) CAShapeLayer *Line_Red;
@property (nonatomic,  strong) CAShapeLayer *Line_Green;

@property (nonatomic, strong) NSArray *numberData;
@property (nonatomic,  strong) CAShapeLayer *renji;
@property (nonatomic,  strong) NSArray *rects;
@property (nonatomic,  strong) NSArray *aiData;
@property (nonatomic,  strong) NSArray *hpData;
@property (nonatomic,  strong) NSArray *disData;
@property (nonatomic,  strong) NSArray *nameData;
@property (nonatomic,  strong) NSArray *data1;
@property (nonatomic,  strong) NSArray *data2;
@property (nonatomic,  strong) NSArray *data3;
@property (nonatomic,  strong) NSArray *data4;
@property (nonatomic,  strong) NSArray *data5;
@property (nonatomic,  strong) NSArray *data6;
@property (nonatomic,  strong) NSArray *data7;
@property (nonatomic,  strong) NSArray *data8;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *juli;
@property (nonatomic,  weak) NSTimer *timer;
@property  char renshu;

@property (nonatomic, copy) NSString *zhutitle;
@property (nonatomic, copy) NSString *fubiaoti;
@property (nonatomic, copy) NSString *kaiguan;
@property (nonatomic, copy) NSString *shexian;
@property (nonatomic, copy) NSString *guge;
@property (nonatomic, copy) NSString *xuetiao;
@property (nonatomic, copy) NSString *xinxi;
@property (nonatomic, copy) NSString *fujin;
@property (nonatomic, copy) NSString *quan;




@end


float headx;
float heady;
#define Red 0x990000ff
#define Green 0x9900FF00
#define Yellow 0x9900ffff
#define Blue 0x99ff0000
#define Pink 0x99eb8cfe
#define White 0xffffffff

@implementation ImGuiDrawView


static bool MenDeal = true;


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImFontConfig config;
    ImGuiIO& io = ImGui::GetIO(); (void)io;
//НАСТРОЙКА ЦВЕТА МЕНЮ
      ImGui::StyleColorsDark();
    
//НАСТРОЙКА ШРИФТА И ЕГО РАЗМЕРА
    io.Fonts->AddFontFromMemoryTTF(SemiBold, sizeof(SemiBold), 17.f, &config, io.Fonts->GetGlyphRangesCyrillic());



    
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. Выполните любую дополнительную настройку после загрузки view
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
}

- (void)conData:(NSArray *)rects hpData:(NSArray *)hpData disData:(NSArray *)disData nameData:(NSArray *)nameData aiData:(NSArray *)aiData numberData:(NSArray *)numberData data1:(NSArray *)data1  data2:(NSArray *)data2 data3:(NSArray *)data3 data4:(NSArray *)data4 data5:(NSArray *)data5 data6:(NSArray *)data6 data7:(NSArray *)data7 data8:(NSArray *)data8
{

    _rects = rects;
    _hpData = hpData;
    _disData = disData;
    _nameData = nameData;
    _aiData = aiData;
    _numberData = numberData;
    _data1 =  data1;
    _data2 =  data2;
    _data3 =  data3;
    _data4 =  data4;
    _data5 =  data5;
    _data6 =  data6;
    _data7 =  data7;
    _data8 =  data8;
     _numberLabel.text = @(_rects.count).stringValue;
//



}







#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
    
    [self doTheJob];
    NSLog(@"99999888===%lu",(unsigned long)_rects.count);
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    static bool show_lien = false;
    static bool show_guge = false;
    static bool show_name = false;
    static bool show_round = false;
    static bool show_number = false;
    static bool show_xuetiao = false;
    static bool show_xinxi = false;
    static bool show_wuhou = false;
    static bool show_fanwei = false;
    static bool show_neifang = false;
    static bool show_L = false;
    static bool show_L1 = false;
    static bool show_L2 = false;
    static bool show_L3 = false;
        static int e = 0;

static int ded = 0;

        static int circle_size = 0;
        
        //
        if (MenDeal == true) {
            [self.view setUserInteractionEnabled:YES];
        } else if (MenDeal == false) {
            [self.view setUserInteractionEnabled:NO];
        }

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            //размер окна
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 420) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 420) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(720, 640), ImGuiCond_FirstUseEver);
            
            if (MenDeal == true)
            {

                ImGui::Begin("Kust;)",  &MenDeal, ImGuiWindowFlags_NoResize);

ImGui::SetCursorPos(ImVec2(523, 30));
    ImGui::BeginGroup();
    {


		if (ImGui::Button("Day", ImVec2(70 - 15, 41)))
      Settings::Tab = 5;

      ImGui::SameLine();

		if (ImGui::Button("Night", ImVec2(70 - 15, 41)))
      Settings::Tab = 6;
}
    ImGui::EndGroup();

    ImGui::Columns(2);
    ImGui::SetColumnOffset(1, 230);

  {
     //левая сторона


		ImGui::PushStyleColor(ImGuiCol_Button, Settings::Tab == 1 ? true : false);
		if (ImGui::Button(" Visuals", ImVec2(230 - 15, 41)))
			Settings::Tab = 1;

		ImGui::Spacing();
		ImGui::PushStyleColor(ImGuiCol_Button, Settings::Tab == 2 ? true : false);
		if (ImGui::Button(" Main", ImVec2(230 - 15, 41)))
			Settings::Tab = 2;

		ImGui::Spacing();
		ImGui::PushStyleColor(ImGuiCol_Button, Settings::Tab == 3 ? true : false);
		if (ImGui::Button(" Settins", ImVec2(230 - 15, 41)))
			Settings::Tab = 3;

		ImGui::Spacing();
		ImGui::PushStyleColor(ImGuiCol_Button, Settings::Tab == 4 ? true : false);
		if (ImGui::Button(" Config", ImVec2(230 - 15, 41)))
			Settings::Tab = 4;

	}

	ImGui::NextColumn();

	//Right side
	
		
if (Settings::Tab == 3)

//пример офсетпатча
        		
       if (show_L3) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
              vm_writeData(0X104B1BC8C, 0x00F0271E);
                 
             });
            }

               
ImGui::End();


	ImGuiStyle* style = &ImGui::GetStyle();

	style->WindowBorderSize = 0;
	style->WindowTitleAlign = ImVec2(0.5, 0.5);
	style->WindowMinSize = ImVec2(500, 450);

	style->FramePadding = ImVec2(8, 6);

	style->Colors[ImGuiCol_TitleBg] = ImColor(255, 101, 53, 255);
	style->Colors[ImGuiCol_TitleBgActive] = ImColor(255, 101, 53, 255);
	style->Colors[ImGuiCol_TitleBgCollapsed] = ImColor(0, 0, 0, 130);

	style->Colors[ImGuiCol_Button] = ImColor(31, 30, 31, 255);
	style->Colors[ImGuiCol_ButtonActive] = ImColor(31, 30, 31, 255);
	style->Colors[ImGuiCol_ButtonHovered] = ImColor(41, 40, 41, 255);

	style->Colors[ImGuiCol_Separator] = ImColor(70, 70, 70, 255);
	style->Colors[ImGuiCol_SeparatorActive] = ImColor(76, 76, 76, 255);
	style->Colors[ImGuiCol_SeparatorHovered] = ImColor(76, 76, 76, 255);

	style->Colors[ImGuiCol_FrameBg] = ImColor(37, 36, 37, 255);
	style->Colors[ImGuiCol_FrameBgActive] = ImColor(37, 36, 37, 255);
	style->Colors[ImGuiCol_FrameBgHovered] = ImColor(37, 36, 37, 255);

	style->Colors[ImGuiCol_Header] = ImColor(0, 0, 0, 0);
	style->Colors[ImGuiCol_HeaderActive] = ImColor(0, 0, 0, 0);
	style->Colors[ImGuiCol_HeaderHovered] = ImColor(46, 46, 46, 255);
  
             
                
            }

            ImDrawList* draw_list = ImGui::GetForegroundDrawList();
            float wanjia =0;
            for (int i = 0; i < self->_rects.count; i++) {
                   
                NSValue *val0  = self->_rects[i];
                NSNumber *val1 = self->_hpData[i];
                NSNumber *val2 = self->_disData[i];
                NSNumber *val3 = self->_aiData[i];
                   
                NSValue *d1  = self->_data1[i];
                NSValue *d2  = self->_data2[i];
                NSValue *d3  = self->_data3[i];
                NSValue *d4  = self->_data4[i];
                NSValue *d5  = self->_data5[i];
                NSValue *d6  = self->_data6[i];
                NSValue *d7  = self->_data7[i];
                NSValue *d8  = self->_data8[i];
                self->_Name = _nameData[i];
                CGRect rect = [val0 CGRectValue];
                CGFloat xue = [val1 floatValue];
                CGFloat dis = [val2 floatValue];
                CGRect rect1 = [d1 CGRectValue];
                CGRect rect2 = [d2 CGRectValue];
                CGRect rect3 = [d3 CGRectValue];
                CGRect rect4 = [d4 CGRectValue];
                CGRect rect5 = [d5 CGRectValue];
                CGRect rect6 = [d6 CGRectValue];
                CGRect rect7 = [d7 CGRectValue];
                CGRect rect8 = [d8 CGRectValue];

                _renshu =self->_rects.count;
                _juli =[NSString stringWithFormat:@"[%.1fSağlık]",xue]; //КОЛИЧЕСТВО ХП

                CGFloat headx = rect1.origin.x/kScale;
                CGFloat heady = rect1.origin.y/kScale;
                CGFloat Spinex = rect1.size.width/kScale;
                CGFloat Spiney = rect1.size.height/kScale;
                CGFloat pelvisx = rect2.origin.x/kScale;
                CGFloat pelvisy = rect2.origin.y/kScale;
                CGFloat leftShoulderx = rect2.size.width/kScale;
                CGFloat leftShouldery = rect2.size.height/kScale;
                CGFloat leftElbowx = rect3.origin.x/kScale;
                CGFloat leftElbowy = rect3.origin.y/kScale;
                CGFloat leftHandx = rect3.size.width/kScale;
                CGFloat leftHandy = rect3.size.height/kScale;
                CGFloat rightShoulderx = rect4.origin.x/kScale;
                CGFloat rightShouldery = rect4.origin.y/kScale;
                CGFloat rightElbowx = rect4.size.width/kScale;
                CGFloat rightElbowy = rect4.size.height/kScale;
                CGFloat rightHandx = rect5.origin.x/kScale;
                CGFloat rightHandy = rect5.origin.y/kScale;
                CGFloat leftPelvisx = rect5.size.width/kScale;
                CGFloat leftPelvisy = rect5.size.height/kScale;
                CGFloat leftKneex = rect6.origin.x/kScale;
                CGFloat leftKneey = rect6.origin.y/kScale;
                CGFloat leftFootx = rect6.size.width/kScale;
                CGFloat leftFooty = rect6.size.height/kScale;
                CGFloat rightPelvisx = rect7.origin.x/kScale;
                CGFloat rightPelvisy = rect7.origin.y/kScale;
                CGFloat rightKneex = rect7.size.width/kScale;
                CGFloat rightKneey = rect7.size.height/kScale;
                CGFloat rightFootx = rect8.origin.x/kScale;
                CGFloat rightFooty = rect8.origin.y/kScale;
                float xd = rect.origin.x+rect.size.width/2;
                float yd = rect.origin.y;
                
                CGFloat w = rect.size.width;
                CGFloat h = rect.size.height;
             
                wanjia+=1;
                if ([val3 intValue] == 1) {
                    self->_Name=[NSString stringWithFormat:@"    人机"];
                }
                if (xue<1) {
                    _Name=[NSString stringWithFormat:@"击倒"];
                }
              
                if (show_lien) {
                    if ([_Name containsString:@"Ai"]) {
                        draw_list->AddLine(ImVec2(kWidth*0.5, 40), ImVec2(xd, yd-60), Green,0.1);
                    }else{
                        draw_list->AddLine(ImVec2(kWidth*0.5, 40), ImVec2(xd, yd-40), Green,0.1);
                        
                    }
                    
                }
             
                if (show_xuetiao) {
                    if (xue>0) {
                      
                        draw_list->AddRectFilled(ImVec2(xd-50, yd-12), ImVec2(xd-50+xue, yd-8), Red);
                   
                        draw_list->AddRectFilled(ImVec2(xd-50+xue, yd-8), ImVec2(xd+50, yd-12), Green);
                    }
                    
                    
                    draw_list->AddLine(ImVec2(xd-5, yd-9), ImVec2(xd, yd-6), Green);
                    draw_list->AddLine(ImVec2(xd, yd-6), ImVec2(xd+5, yd-9), Green);
                    
                }
             
                if (show_xinxi) {
                    if ([_Name containsString:@"Ai"]) {
                      
                        draw_list->AddRectFilled(ImVec2(xd-30, yd-30), ImVec2(xd+30, yd-11), Green);
                       
                        draw_list->AddRectFilled(ImVec2(xd-30, yd-10), ImVec2(xd-30, yd-11), Blue);
                       
                        char* ii = (char*) [[NSString stringWithFormat:@"%d",(int)i+1] cStringUsingEncoding:NSUTF8StringEncoding];
                        draw_list->AddText(ImGui::GetFont(), 20, ImVec2(xd-25, yd-31), White, ii);
                        
                    }
                    else if ([_Name containsString:@"击倒"]) {
                  
                        draw_list->AddRectFilled(ImVec2(xd-30, yd-30), ImVec2(xd+30, yd-11), Blue);
                      
                        draw_list->AddRectFilled(ImVec2(xd-30, yd-10), ImVec2(xd-30, yd-11), Blue);
                     
                        char* ii = (char*) [[NSString stringWithFormat:@"%d",(int)i+1] cStringUsingEncoding:NSUTF8StringEncoding];
                        draw_list->AddText(ImGui::GetFont(), 20, ImVec2(xd-25, yd-31), White, ii);
                       
                    }
                    else{
                       
                        draw_list->AddRectFilled(ImVec2(xd-50, yd-30), ImVec2(xd+50, yd-11), Blue);
                        
                        draw_list->AddRectFilled(ImVec2(xd-50, yd-30), ImVec2(xd-30, yd-11), Blue);
                     
                        char* ii = (char*) [[NSString stringWithFormat:@"%d",(int)i+1] cStringUsingEncoding:NSUTF8StringEncoding];
                        draw_list->AddText(ImGui::GetFont(), 20, ImVec2(headx-45, yd-31), White, ii);
                    }
                    
                   
                    
                }
                // ЕСП Скелетон ИЛИ ЖЕ КОСТИ
                if (show_guge) {
                    
                    if ([_Name containsString:@"    人机"]) {
                        draw_list->AddLine(ImVec2(headx, heady), ImVec2(Spinex, Spiney), Green);
                        draw_list->AddLine(ImVec2(Spinex, Spiney), ImVec2(pelvisx, pelvisy), Green);
                        //盆骨》左盆骨》左膝盖》左脚
                        draw_list->AddLine(ImVec2(pelvisx, pelvisy), ImVec2(leftPelvisx, leftPelvisy), Green);
                        draw_list->AddLine(ImVec2(leftPelvisx, leftPelvisy), ImVec2(leftKneex, leftKneey), Green);
                        draw_list->AddLine(ImVec2(leftKneex, leftKneey), ImVec2(leftFootx, leftFooty), Green);
                        //盆骨》右盆骨》右膝盖》右脚
                        draw_list->AddLine(ImVec2(pelvisx, pelvisy), ImVec2(rightPelvisx, rightPelvisy), Green);
                        draw_list->AddLine(ImVec2(rightPelvisx, rightPelvisy), ImVec2(rightKneex, rightKneey), Green);
                        draw_list->AddLine(ImVec2(rightKneex, rightKneey), ImVec2(rightFootx, rightFooty), Green);
                        //右手》右手肘》右肩膀》左肩膀》左手肘》左手
                        draw_list->AddLine(ImVec2(rightHandx, rightHandy), ImVec2(rightElbowx, rightElbowy), Green);
                        draw_list->AddLine(ImVec2(rightElbowx, rightElbowy), ImVec2(rightShoulderx, rightShouldery), Green);
                        draw_list->AddLine(ImVec2(rightShoulderx, rightShouldery), ImVec2(leftShoulderx, leftShouldery), Green);
                        draw_list->AddLine(ImVec2(leftShoulderx, leftShouldery), ImVec2(leftElbowx, leftElbowy), Green);
                        draw_list->AddLine(ImVec2(leftElbowx, leftElbowy), ImVec2(leftHandx, leftHandy), Green);
                    }else{
                        draw_list->AddLine(ImVec2(headx, heady), ImVec2(Spinex, Spiney), Yellow);
                        draw_list->AddLine(ImVec2(Spinex, Spiney), ImVec2(pelvisx, pelvisy), Yellow);
                        //盆骨》左盆骨》左膝盖》左脚
                        draw_list->AddLine(ImVec2(pelvisx, pelvisy), ImVec2(leftPelvisx, leftPelvisy), Yellow);
                        draw_list->AddLine(ImVec2(leftPelvisx, leftPelvisy), ImVec2(leftKneex, leftKneey), Yellow);
                        draw_list->AddLine(ImVec2(leftKneex, leftKneey), ImVec2(leftFootx, leftFooty), Yellow);
                        //盆骨》右盆骨》右膝盖》右脚
                        draw_list->AddLine(ImVec2(pelvisx, pelvisy), ImVec2(rightPelvisx, rightPelvisy), Yellow);
                        draw_list->AddLine(ImVec2(rightPelvisx, rightPelvisy), ImVec2(rightKneex, rightKneey), Yellow);
                        draw_list->AddLine(ImVec2(rightKneex, rightKneey), ImVec2(rightFootx, rightFooty), Yellow);
                        //右手》右手肘》右肩膀》左肩膀》左手肘》左手
                        draw_list->AddLine(ImVec2(rightHandx, rightHandy), ImVec2(rightElbowx, rightElbowy), Yellow);
                        draw_list->AddLine(ImVec2(rightElbowx, rightElbowy), ImVec2(rightShoulderx, rightShouldery), Yellow);
                        draw_list->AddLine(ImVec2(rightShoulderx, rightShouldery), ImVec2(leftShoulderx, leftShouldery), Yellow);
                        draw_list->AddLine(ImVec2(leftShoulderx, leftShouldery), ImVec2(leftElbowx, leftElbowy), Yellow);
                        draw_list->AddLine(ImVec2(leftElbowx, leftElbowy), ImVec2(leftHandx, leftHandy), Yellow);
                    }
                    
                    
                }

     
           
                //ЕСП ИМЯ И ДИСТАНЦИЯ
                if (show_name) {
                    char* TermConfig = (char*) [_Name cStringUsingEncoding:NSUTF8StringEncoding];
                    char* distxt = (char*) [_juli cStringUsingEncoding:NSUTF8StringEncoding];
                    draw_list->AddText(ImGui::GetFont(), 15, ImVec2(xd-20, yd-45), 0xFF00FF00, distxt);
                    if ([_Name containsString:@"击倒"]) {
                        draw_list->AddText(ImGui::GetFont(), 15, ImVec2(xd-10, yd-29), White, TermConfig);
                    }else{
                        draw_list->AddText(ImGui::GetFont(), 15, ImVec2(xd-26, yd-29), Blue, TermConfig);
                    }
                    
                    
                   
                }
            }
        //КОЛИЧЕСТВО ЛЮДЕЙ ВО КРУГ
            if (show_number) {
                 char* newnumber = (char*) [[NSString stringWithFormat:@"%d ",_renshu] cStringUsingEncoding:NSUTF8StringEncoding];
                draw_list->AddText(ImGui::GetFont(), 45, ImVec2(kWidth/2, 15), 0xFFCCFFFF,newnumber);
                
                
            }
            //РИСОВКА КРАСНОГО КРУГА
            if (show_round) draw_list->AddCircle(ImVec2(kWidth/2, kHeight/2), circle_size, 0xFF6666FF);

              
        
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}


- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}
- (void)fuyanqaq:(NSArray *)rects hpData:(NSArray *)hpData disData:(NSArray *)disData nameData:(NSArray *)nameData aiData:(NSArray *)aiData data1:(NSArray *)data1  data2:(NSArray *)data2 data3:(NSArray *)data3 data4:(NSArray *)data4 data5:(NSArray *)data5 data6:(NSArray *)data6 data7:(NSArray *)data7 data8:(NSArray *)data8
{
    self->_rects = rects;
    self->_hpData = hpData;
    self->_disData = disData;
    self->_nameData = nameData;
    self->_aiData = aiData;
    self->_data1 =  data1;
    self->_data2 =  data2;
    self->_data3 =  data3;
    self->_data4 =  data4;
    self->_data5 =  data5;
    self->_data6 =  data6;
    self->_data7 =  data7;
    self->_data8 =  data8;
    
}
- (void)doTheJob
{

    [[lvllzuobiao data] fetchData:^(NSArray * _Nonnull data, NSArray * _Nonnull hpData, NSArray * _Nonnull disData,  NSArray * _Nonnull nameData,  NSArray * _Nonnull aiData, NSArray * _Nonnull data1, NSArray * _Nonnull data2, NSArray * _Nonnull data3, NSArray * _Nonnull data4, NSArray * _Nonnull data5, NSArray * _Nonnull data6, NSArray * _Nonnull data7, NSArray * _Nonnull data8) {
         NSLog(@"%@",data1);
        [self fuyanqaq:data hpData:hpData disData:disData nameData:nameData aiData:aiData data1:data1 data2:data2 data3:data3 data4:data4 data5:data5 data6:data6 data7:data7 data8:data8];
    }];

}



@end

