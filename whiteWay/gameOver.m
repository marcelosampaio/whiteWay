//
//  gameOver.m
//  whiteWay
//
//  Created by Marcelo Sampaio on 11/30/13.
//  Copyright (c) 2013 Marcelo Sampaio. All rights reserved.
//

#import "gameOver.h"
#import "MyScene.h"

@implementation gameOver

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    
    if (self = [super initWithSize:size]) {
        
        // 1
        self.backgroundColor =[SKColor redColor];
        //self.backgroundColor = [SKColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        
        // 2
        NSString *message;
        NSString *message2;
        if (won) {
            self.backgroundColor =[SKColor greenColor];
            
            // NUNCA ENTRA AQUI
            message = @"";
        } else {
            self.backgroundColor =[SKColor redColor];
            message = @"Evite as nuvens de chuva!";
            message2 = @"Avoid thunder clouds!";
        }
        
        // 3
        
        // Colocar imagem da ThunderCloud bem no meio do GameOVer Scene
        // ------------------------------------------------------------
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 18;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMinY(self.frame)+(CGRectGetMidY(self.frame)/1.3));
        [self addChild:label];
        
        
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label2.text = message2;
        label2.fontSize = 18;
        label2.fontColor = [SKColor whiteColor];
        label2.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMaxY(self.frame)-(CGRectGetMidY(self.frame)/1.3));
        [self addChild:label2];
        
        
        
        // Coloca os créditos do app
        SKLabelNode *label3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label3.text = @"Marcelo Sampaio (game)";
        label3.fontSize = 14;
        label3.fontColor = [SKColor yellowColor];
        label3.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMinY(self.frame)+(CGRectGetMidY(self.frame)/4));
        [self addChild:label3];
        
        
        // 4
        NSLog(@"em gameOver Scene pronto para runAction e voltar ao chamador ");
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:0.5],
                              [SKAction runBlock:^{
             // 5
             SKTransition *reveal = [SKTransition crossFadeWithDuration:1];

             SKScene *gameOverScene = [[MyScene alloc]initWithSize:self.size];
             gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
             [self.view presentScene:gameOverScene transition: reveal];
         }]
                              ]]
         ];
        
    }
    return self;
}


@end
