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
@property int gameDriverColumn;
@property int gameDriverCell;
@property BOOL gameDriverDidMove;
@property BOOL gameBoardOK;
@property BOOL gameBoardEngineIsOn;
@property BOOL gameTimerIsOn;
@property float gameBoardTimerInterval;
@property(nonatomic,retain) NSTimer *gameTimer;
@property float MidX;
@property float MidY;
@property int tamanhoBase;
@property BOOL removerBolaAmarelaInicial;

// Contador para controle do GameOver Scene
@property long gameOverSceneInternalCounter;

// Tabuleiro do jogo
@property (nonatomic,strong) NSMutableDictionary *tabuleiro;
@property (nonatomic,strong) NSMutableArray *objetosDoTabuleiro;
@property (nonatomic,strong) NSMutableDictionary *tabuleiroAuxiliar;



// Titulo do game para animacao
//@property(strong,nonatomic) SKLabelNode *gameTitle;

@end


