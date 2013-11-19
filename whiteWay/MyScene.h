//
//  MyScene.h
//  whiteWay
//

//  Copyright (c) 2013 Marcelo Sampaio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

// Gestão do tempo
@property long timeUnit;            // Unidade de tempo
@property long timeTen;             // Dezena de tempo
@property long timeHundred;         // Centena de tempo
@property long timeMillion;         // Milhao de tempo
@property long timeBillion;         // Bilhao de tempo
@property long timeTrillion;        // Trilhao de tempo

// Propriedade para saber se a animacao inicial já terminou
@property BOOL gameBoardOK;
@property float MidX;
@property float MidY;

// Titulo do game para animacao
//@property(strong,nonatomic) SKLabelNode *gameTitle;

@end


