//
//  MyScene.m
//  whiteWay
//
//  Created by Marcelo Sampaio on 11/9/13.
//  Copyright (c) 2013 Marcelo Sampaio. All rights reserved.
//

#define TIME_FACTOR 10

#import "MyScene.h"

@implementation MyScene


@synthesize timeUnit,timeTen,timeHundred,timeMillion,timeBillion,timeTrillion;
@synthesize gameBoardOK,gameBoardEngineIsOn,gameTimerIsOn,gameTimer,gameBoardTimerInterval;
@synthesize MidX,MidY,tamanhoBase;
@synthesize tabuleiro,tabuleiroAuxiliar;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0];
        self.gameBoardOK=NO;
        self.gameBoardEngineIsOn=NO;
        self.gameTimerIsOn=NO;
        self.gameBoardTimerInterval=3.00f;
        self.tabuleiro=[[NSMutableDictionary alloc]initWithCapacity:49];
    }
    return self;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
////    for (UITouch *touch in touches) {
////        CGPoint location = [touch locationInNode:self];
////    }
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    // Time management - Getting timePulse
    long timePulse=[self timeCounter];

    // =================================================
    // Time Tasks - tasks executed along game's timeline
    // =================================================
    // ==== UNIDADE 0 - 300 =  Game Title Animation
    if (timePulse==10)
    {
        [self animateIntroduction];
    }
    // Testa se já pode criar o tabuleiro do jogo
    if (self.gameBoardOK) {
        [self addGameBoardForTheFirstTime:YES];
        self.gameBoardOK=NO;  // Fim do ciclo de vida do tabuleiro inicial
    }
    
    // Por volta de timePulse=250 podemos iniciar as movimentações de colunas
    // ----------------------------------------------------------------------
    if (timePulse==250) {
        // Antes de iniciar a movimentação devemos criar a bola amarela primeiro em seu ponto inicial
        [self addInitialBall];
    }
    //
    // Processamento do Loop Principal do Game (somente interrompido quando move-se o amarelo!!!!!

    // Verifico se o jogo já está pronto para iniciar os movimentos
    if (self.gameBoardEngineIsOn) {
        // Somente ligo time 1 vez. Ele somente sera interrompindo pelo swipe e religado por la
        if (!self.gameTimerIsOn) {
            // Main Game Timer gains controll over the game board
            self.gameTimer=[NSTimer scheduledTimerWithTimeInterval:self.gameBoardTimerInterval target:self selector:@selector(timerLoopOnProcessing) userInfo:nil repeats:YES];
            [self.gameTimer fire];
            self.gameTimerIsOn=YES;
        }
    }
    
}

-(void)animateIntroduction
{
    // adicionando Label Titulo do Game
    SKLabelNode *gameTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //    self.gameTitle.text = @"White Way";
    gameTitle.text=@"White Way";
    gameTitle.name=gameTitle.text;
    gameTitle.fontSize = 60;
    gameTitle.position = CGPointMake(CGRectGetMidX(self.frame),
                                     CGRectGetMidY(self.frame));
    gameTitle.zPosition=100;
    gameTitle.alpha=0;
    gameTitle.color=[SKColor whiteColor];
    gameTitle.colorBlendFactor=1;
    
    [self addChild:gameTitle];

    // adicionando Bola Amarela Correndo para a esquerda
    SKSpriteNode *runningBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    runningBall.name=@"Running Ball";
    runningBall.position = CGPointMake(CGRectGetMinX(self.frame)-70,
                                     CGRectGetMidY(self.frame));
    runningBall.zPosition=0;
    runningBall.alpha=1;
    runningBall.xScale=0.55;
    runningBall.yScale=0.55;
    runningBall.color=[SKColor yellowColor];
    runningBall.colorBlendFactor=1;
    
    [self addChild:runningBall];
    
    // Animacao em etapas
    // 1- fade to 1
    // 2- fade to 0
    // 3- remove title
    SKAction *action = [SKAction fadeAlphaTo:1 duration:2];
    SKAction *animaBolaAmarela = [SKAction moveToX:CGRectGetMaxX(self.frame)+100 duration:2.00f];   // 2.80
    SKAction *action2 = [SKAction fadeAlphaTo:0 duration:2];
    [gameTitle runAction:action completion:^{
        [runningBall runAction:action2];
        [runningBall runAction:animaBolaAmarela];
        [gameTitle runAction:action2 completion:^{
            [gameTitle removeFromParent];
            self.gameBoardOK=YES;
        }];
    }];

}

-(long)timeCounter
{
    // Criação da Unidade
    self.timeUnit=self.timeUnit+1;
    
    // Criação da Dezena
    if (self.timeUnit==TIME_FACTOR) {
        self.timeTen=self.timeTen+1;
        self.timeUnit=0;
    }
    
    // Criação da Centena
    if (self.timeTen==TIME_FACTOR) {
        self.timeHundred=self.timeHundred+1;
        self.timeTen=0;
    }

    // Criação da Milhar
    if (self.timeHundred==TIME_FACTOR) {
        self.timeMillion=self.timeMillion+1;
        self.timeHundred=0;
    }

    // Criação da Bilhar
    if (self.timeMillion==TIME_FACTOR) {
        self.timeBillion=self.timeBillion+1;
        self.timeMillion=0;
    }
    
    // Criação da Trilhar
    if (self.timeBillion==TIME_FACTOR) {
        self.timeTrillion=self.timeTrillion+1;
        self.timeBillion=0;
    }
    
    // Long value to be returned
    long longNumber=self.timeUnit+(self.timeTen*10)+(self.timeHundred*100)+(self.timeMillion*1000)+(self.timeBillion*1000000)+(self.timeTrillion*1000000000);
    
    return longNumber;

    
}
// ========================================
// Método para criação do tabuleiro de jogo
// ========================================
-(void)addGameBoardForTheFirstTime:(BOOL)isFirstTime
{
    // Inicializa o tabuleiro Auxiliar
    self.tabuleiroAuxiliar=[[NSMutableDictionary alloc]initWithDictionary:self.tabuleiro];
    
    self.MidX=CGRectGetMidX(self.frame);
    self.MidY=CGRectGetMidY(self.frame);
    self.tamanhoBase=80; // iPad Resolution
    
    int totalLinhas=7;
    int totalColunas=7;
    
    if (isFirstTime) // É a primeira vez
    {
        for (int i=0; i<totalColunas; i++) {
            for (int j=0; j<totalLinhas; j++) {
                SKSpriteNode *boardCell = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
                boardCell.name=[NSString stringWithFormat:@"%d%d",i+1,j+1];
                CGPoint coordenadasDaCelula=[self getBoardCellPointAtRow:i+1 Column:j+1];
                boardCell.position=coordenadasDaCelula;
                boardCell.zPosition=0;
                boardCell.alpha=1;
                boardCell.xScale=0.55;
                boardCell.yScale=0.55;
                boardCell.colorBlendFactor=1;
                // Obtem a cor da celula
                boardCell.color=[self gameBoardRowColor:i+1 gameBoardColumnColor:j+1 firstTime:isFirstTime];
                [self addChild:boardCell];
            }
        }
    } else    // Não é a primeira vez
    {
        // somente os nascentes recebem nova cor de celula os demais são movimentados ( anterior->proximo )
        
    }
    
    

}

-(void)addInitialBall
{
    SKSpriteNode *initialBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    initialBall.name=@"9";
    CGPoint coordenadasDaCelula=[self getBoardCellPointAtRow:0 Column:0];
    initialBall.position=CGPointMake(CGRectGetMinX(self.frame), coordenadasDaCelula.y);
    initialBall.zPosition=0;
    initialBall.alpha=1;
    initialBall.xScale=0.55;
    initialBall.yScale=0.55;
    initialBall.colorBlendFactor=1;
    // Obtem a cor da celula
    initialBall.color=[self gameBoardRowColor:0 gameBoardColumnColor:0 firstTime:NO];
    [self addChild:initialBall];
    
    // Anima a chegada da Bola
    SKAction *animaBolaInicial = [SKAction moveToX:coordenadasDaCelula.x duration:0.35f];
    [initialBall runAction:animaBolaInicial completion:^{
        self.gameBoardEngineIsOn=YES;
    }];
    
    
}




// Metodo para obtencao da posicao de cada celula no tabuleiro do jogo
-(CGPoint)getBoardCellPointAtRow:(int)linha Column:(int)coluna
{
    CGFloat xCoordinate=0.00f;
    CGFloat yCoordinate=0.00f;
    //Tratamento de X
    if (coluna==0) {
        xCoordinate=self.MidX-self.tamanhoBase*4;
    } else if (coluna==1) {
        xCoordinate=self.MidX-self.tamanhoBase*3;
    } else if (coluna==2) {
        xCoordinate=self.MidX-self.tamanhoBase*2;
    } else if (coluna==3) {
        xCoordinate=self.MidX-self.tamanhoBase;
    } else if (coluna==4) {
        xCoordinate=self.MidX;
    } else if (coluna==5) {
        xCoordinate=self.MidX+self.tamanhoBase;
    } else if (coluna==6) {
        xCoordinate=self.MidX+self.tamanhoBase*2;
    } else if (coluna==7) {
        xCoordinate=self.MidX+self.tamanhoBase*3;
    }

    //Tratamento de Y
    if (linha==0) {
        yCoordinate=self.MidY+self.tamanhoBase*3;
    } else if (linha==1) {
        yCoordinate=self.MidY+self.tamanhoBase*3;
    } else if (linha==2) {
        yCoordinate=self.MidY+self.tamanhoBase*2;
    } else if (linha==3) {
        yCoordinate=self.MidY+self.tamanhoBase;
    } else if (linha==4) {
        yCoordinate=self.MidY;
    } else if (linha==5) {
        yCoordinate=self.MidY-self.tamanhoBase;
    } else if (linha==6) {
        yCoordinate=self.MidY-self.tamanhoBase*2;
    } else if (linha==7) {
        yCoordinate=self.MidY-self.tamanhoBase*3;
    }

    return CGPointMake(xCoordinate, yCoordinate);
}

-(UIColor *)gameBoardRowColor:(int)linha gameBoardColumnColor:(int)coluna firstTime:(BOOL)isFirstTime
{
    // Tratamento da cor de cada celula
    //  0- Preto
    //  1- Branco
    //  2- Amarelo 
    if (linha==0 && coluna==0) {
        return [UIColor yellowColor];
    }
    // Se for a primeira vez entao a cor é randomica para todas as celullas
    // Senao a cor randomicame se aplica apenas as nascentes
    // Cor da proxima é a cor da anterior
    NSString *cell=[NSString stringWithFormat:@"%d",linha*10+coluna];
    
    if (isFirstTime || [cell isEqualToString:@"11"] || [cell isEqualToString:@"13"] || [cell isEqualToString:@"15"] || [cell isEqualToString:@"17"] || [cell isEqualToString:@"72"] || [cell isEqualToString:@"74"] || [cell isEqualToString:@"76"]) {
        // Leva em consideracao o dicionario tabuleiro para esta criacao de cores no tabuleiro
        int probabilidade=9;
        int randomIndex=arc4random() % probabilidade;
        if (randomIndex<=3) {
            // Armazena propriedades da celula do tabuleiro -- 1 Para BRANCO
            [self.tabuleiro setValue:[NSString stringWithFormat:@"1"] forKey:[NSString stringWithFormat:@"%d",(linha*10)+coluna]];
            return [UIColor whiteColor];
        }
        // -- 0 Para PRETO
        [self.tabuleiro setValue:[NSString stringWithFormat:@"0"] forKey:[NSString stringWithFormat:@"%d",(linha*10)+coluna]];
        return [UIColor blackColor];

    }
    
    // Tratamento de NÃO É A PRIMEIRA VEZ
    // ----------------------------------
    NSLog(@"para continuar ----->%d",[self.tabuleiro count]);
    
    
    return [UIColor whiteColor];
}


-(void)timerLoopOnProcessing
{
    // Movimenta o tabuleiro
    [self addGameBoardForTheFirstTime:NO];
}



@end
