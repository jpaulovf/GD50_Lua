--[[
    BONG - Uma releitura de PONG
    Desenvolvido como exercício para o curso GD50
    Baseado no Pong de Colton Ogden
    https://github.com/games50/pong

    Feito para a engine LÖVE2D

    Usando a lib 'push' para dar uma estética retro
    (OBS: usar a versão atualizada para o LÖVE 11+)

    https://github.com/Ulydev/push

]]

-- Importando a lib push
push = require 'push'

--[[
    Constantes
]]

-- Resolução real da tela
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Resolução virtual da tela
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Velocidade dos paddles
PADDLE_SPEED = 200

--[[ 
    Inicialização do jogo
 ]]
function love.load()

    -- Configurações de filtro
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- gerando um seed aleatório baseado no relógio do sistema
    -- usado para as funções de movimentação da bola
    math.randomseed(os.time())

    -- Criando uma fonte com tamanho 8
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- Criando outra fonte com tamanho 32
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Carregando a font smallFont
    love.graphics.setFont(smallFont)

    -- Configurações da tela (aplicando a resolução virtual)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Variáveis para armazenar a pontuação
    player1Score = 0
    player2Score = 0

    -- Posições iniciais dos paddles no eixo Y (só movem no eixo Y)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- Posição inicial da bola
    ballX = VIRTUAL_WIDTH/2 - 2
    ballY = VIRTUAL_HEIGHT/2 - 2

    -- Velocidade inicial da bola
    -- Usando o operador ternário (math.random(2) == 1? 100 : -100)
    -- math.random(2) retorna um número random entre 1 e 2
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50,50)

    -- Estado inicial do nosso jogo
    gameState = 'start'

end

--[[
    Função de update da tela
]]
function love.update(dt)

    -- movimentação o paddle do player 1 (E)
    if love.keyboard.isDown('w') then
        --player1Y = player1Y + -PADDLE_SPEED*dt
        -- limitando a posição máxima no eixo Y
        player1Y = math.max(0, player1Y - PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('s') then
        --player1Y = player1Y + PADDLE_SPEED*dt
        -- limitando a posição mínima no eixo Y
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED*dt)
       
    end

    -- movimentação do player 2
    if love.keyboard.isDown('up') then
        --player2Y = player2Y + -PADDLE_SPEED*dt
        -- limitando a posição máxima no eixo Y
        player2Y = math.max(0, player2Y - PADDLE_SPEED*dt)
    elseif love.keyboard.isDown('down') then
        --player2Y = player2Y + PADDLE_SPEED*dt
        -- limitando a posição mínima no eixo Y
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED*dt)
    end

    -- movimentação da bola (somente no estado 'play')
    if gameState == 'play' then
        ballX = ballX + ballDX*dt
        ballY = ballY + ballDY*dt
    end


end

--[[
    Handler para quando uma tecla for pressionada
]]
function love.keypressed(key)

    -- Ao pressionar ESC, o jogo termina
    if key == 'escape' then
        love.event.quit()

    -- Ao pressionar 'ENTER', o jogo entra no modo play
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            -- começa de novo
            gameState = 'start'

            -- seta a bola no meio da tela
            ballX = VIRTUAL_WIDTH/2 - 2
            ballY = VIRTUAL_HEIGHT/2 - 2

            -- define novamente a velocidade random da bola
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end

    end

end

--[[
   Desenha as coisas na tela 
]]
function love.draw()

    -- Inicializando a renderização com a resolução virtual
    push:apply('start')

    -- Aplicando uma cor de fundo na tela (cor cinza)
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Printa uma mensagem de acordo com o estado
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Hello, BONG!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Playing BONG!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- Printando o placar
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

    -- Renderizando os paddles

    -- Paddle da esquerda
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    -- Paddle da direita
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- Renderizando a bola
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    -- Fim da renderização
    push:apply('end')

end

