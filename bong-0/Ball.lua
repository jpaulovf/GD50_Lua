--[[

    Classe 'Ball'
    
    Define um objeto que representa a bola do jogo 'Bong'
    Desenvolvido como exercício para o curso GD50
    Baseado no Pong de Colton Ogden
    https://github.com/games50/pong

    Usa a lib 'class', que é chamada em main
    https://github.com/vrld/hump

]]

-- Definindo Ball como uma classe
Ball = Class{}

--[[ 
    Métodos
]]

-- Construtor
function Ball:init(x, y, width, height)

    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- velocidades
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)

end

-- Função que verifica se a bola colidiu com um paddle
function Ball:collides(paddle)

    -- Verificando no eixo x
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Verificando no eixo y
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false 
    end

    return true

end

-- Reseta a bola na posição inicial
function Ball:reset()

    self.x = VIRTUAL_WIDTH/2 - 2
    self.y = VIRTUAL_HEIGHT/2 - 2
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)

end

-- Aplica a velocidade na bola, usando o delta time dt
function Ball:update(dt)

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end

-- Renderiza a bola na tela
function Ball:render()

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end



