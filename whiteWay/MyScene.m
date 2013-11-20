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
//@synthesize gameTitle;
@synthesize gameBoardOK, gameBoardMovements, gameBoardEngineIsOn;
@synthesize MidX,MidY,tamanhoBase;
@synthesize tabuleiro;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0];
        self.gameBoardOK=NO;
        self.gameBoardMovements=NO;
        self.gameBoardEngineIsOn=NO;
        self.tabuleiro=[[NSMutableDictionary alloc]initWithCapacity:49];
        
        // Procedimentos de armazenamento no github ainda em suspenso
        NSLog(@"GITHUB ainda não concluido");
        NSLog(@"retiramos referencias internas do github");
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//        
//    }
}

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
    // Testa o se já pode criar o tabuleiro do jogo
    if (self.gameBoardOK) {
        [self addGameBoard];
        self.gameBoardOK=NO;  // Fim do ciclo de vida do tabuleiro inicial
    }
    
    // Por volta de timePulse=250 podemos iniciar as movimentações de colunas
    // ----------------------------------------------------------------------
    if (timePulse==250) {
        // Antes de iniciar a movimentação devemos criar a bola amarela primeiro em seu ponto inicial
        [self addInitialBall];
        self.gameBoardMovements=YES;
    }
    //
    // Processamento do Loop Principal do Game (somente interrompido quando move-se o amarelo!!!!!
    //
    if (self.gameBoardEngineIsOn) {
        NSLog(@"========= Aqui começa o controle do tempo para os pulsos do jogo!!!!!! ===============");
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
-(void)addGameBoard
{
    self.MidX=CGRectGetMidX(self.frame);
    self.MidY=CGRectGetMidY(self.frame);
    self.tamanhoBase=80; // iPad Resolution
    
    int totalLinhas=7;
    int totalColunas=7;
    
    for (int i=0; i<totalColunas; i++) {
        for (int j=0; j<totalLinhas; j++) {
            SKSpriteNode *runningBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
            runningBall.name=[NSString stringWithFormat:@"%d%d",i+1,j+1];
            CGPoint coordenadasDaCelula=[self getCellPointToLine:i+1 Column:j+1];
            runningBall.position=coordenadasDaCelula;
            runningBall.zPosition=0;
            runningBall.alpha=1;
            runningBall.xScale=0.55;
            runningBall.yScale=0.55;
            runningBall.colorBlendFactor=1;
            // Obtem a cor da celula
            runningBall.color=[self gameBoardRowColor:i+1 gameBoardColumnColor:j+1];;
            
            [self addChild:runningBall];
        }
    }
}

-(void)addInitialBall
{
    SKSpriteNode *initialBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    initialBall.name=@"9";
    CGPoint coordenadasDaCelula=[self getCellPointToLine:0 Column:0];
    initialBall.position=CGPointMake(CGRectGetMinX(self.frame), coordenadasDaCelula.y);
    initialBall.zPosition=0;
    initialBall.alpha=1;
    initialBall.xScale=0.55;
    initialBall.yScale=0.55;
    initialBall.colorBlendFactor=1;
    // Obtem a cor da celula
    initialBall.color=[self gameBoardRowColor:0 gameBoardColumnColor:0];
    [self addChild:initialBall];
    
    // Anima a chegada da Bola
    SKAction *animaBolaInicial = [SKAction moveToX:coordenadasDaCelula.x duration:0.35f];   // 2.80
    [initialBall runAction:animaBolaInicial completion:^{
        self.gameBoardEngineIsOn=YES;
    }];
    
    
}




// Metodo para obtencao da posicao de cada celula no tabuleiro do jogo
-(CGPoint)getCellPointToLine:(int)linha Column:(int)coluna
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

-(UIColor *)gameBoardRowColor:(int)linha gameBoardColumnColor:(int)coluna
{
    // Tratamento da cor de cada celula
    //  0- Preto
    //  1- Branco
    //  2- Amarelo ( neste método o amarelo NUNCA é gerado )
    if (linha==0 && coluna==0) {
        return [UIColor yellowColor];
    }
    
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


@end
