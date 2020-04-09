--[[
    BONG - Uma releitura de PONG
    Desenvolvido como exercício para o curso GD50
    Baseado no Pong de Colton Ogden
    https://github.com/games50/pong

    Feito para a engine LÖVE2D

    Usando a lib 'push' para dar uma estética retro
    (OBS: usar a versão atualizada para o LÖVE 11+)

    https://github.com/Ulydev/push

    Usando a lib 'class' do pacote 'hump'
    Helper Utilities for Massive Progression

    https://github.com/vrld/hump

]]

-- Importando a lib push
push = require 'push'

-- Importando a lib class
Class = require 'class'

-- Importando a Bola
require 'Ball'

-- Importando os paddles
require 'Paddle' 

--[[
    Constantes
]]

-- Resolução real da tela
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

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

    -- Colocando o título na janela
    love.window.setTitle('Bong')

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

    -- Criando os dois paddles (x, y, width, height)
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Criando a bola (x, y, width, height)
    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- Estado inicial do nosso jogo
    gameState = 'start'

end

--[[
    Função de update da tela
]]
function love.update(dt)

    -- Mecânica de colisão
    if gameState == 'play' then

        -- Colidindo com o paddle 1 (E)
        if ball:collides(player1) then
            -- Invertendo a velocidade em x e posicionando a bola
            --  para a superfície do paddle (para evitar q ela entre no paddle)
            ball.dx = -ball.dx * 1.05
            ball.x = player1.x + player1.width

            -- Mantendo a direção em y, mas jogando em um ângulo
            --  aleatório
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- Colidindo com o paddle 1 (E)
        if ball:collides(player2) then
            -- Invertendo a velocidade em x e posicionando a bola
            --  para a superfície do paddle (para evitar q ela entre no paddle)
            ball.dx = -ball.dx * 1.05
            ball.x = player2.x - ball.width

            -- Mantendo a direção em y, mas jogando em um ângulo
            --  aleatório
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

    end

    -- Colisão com os cantos da tela
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - ball.width then
        ball.y = VIRTUAL_HEIGHT - ball.width
        ball.dy = -ball.dy
    end

    -- movimentação o paddle do player 1 (E)
    if love.keyboard.isDown('w') then
        -- indo para cima (velocidade negativa)
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        -- indo para baixo (velocidade positiva)
        player1.dy = PADDLE_SPEED
    else
        -- paddle parado
        player1.dy = 0
    end

    -- movimentação do player 2
    if love.keyboard.isDown('up') then
        -- indo para cima (velocidade negativa)
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        -- indo para cima (velocidade negativa)
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- movimentação da bola (somente no estado 'play')
    if gameState == 'play' then
        ball:update(dt)
    end

    -- Atualizando a posição dos paddles de acordo com a velocidade imprimida
    player1:update(dt)
    player2:update(dt)

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

            -- reseta a posição da bola
            ball:reset()
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
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
        love.graphics.printf('Hello, BONG!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(255/255, 0/255, 255/255, 255/255)
        love.graphics.printf('Playing BONG!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    end

    -- Printando o placar
    --[[
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)
    ]]

    -- Renderizando os paddles
    player1:render()
    player2:render()

    -- Renderizando a bola
    ball:render()

    -- mostrando FPS
    displayFPS()

    -- Fim da renderização
    push:apply('end')

end

-- Mostra o FPS na tela
function displayFPS()

    love.graphics.setFont(smallFont)
    love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 10, 10)

end

