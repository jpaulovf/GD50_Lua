--[[

    Classe 'Paddle'
    
    Define um objeto que representa os paddles do jogo 'Bong'
    Desenvolvido como exercício para o curso GD50
    Baseado no Pong de Colton Ogden
    https://github.com/games50/pong

    Usa a lib 'class', que é chamada em main
    https://github.com/vrld/hump

]]

-- Definindo o paddle como uma classe
Paddle = Class{}

--[[
    Métodos
]]

-- Construtor
function Paddle:init(x, y, width, height)

    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0

end

-- Atualiza a posição do paddle
function Paddle:update(dt)

    -- velocidade negativa (indo para cima)
    if self.dy < 0 then
        -- se chegar ao valor 0, fica lá
        self.y = math.max(0, self.y + self.dy * dt)
    else
        -- se chegar na parte de baixo da tela (menos a altura do paddle),
        -- ele deve parar
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)

    end

end

-- Renderiza o paddle
function Paddle:render()

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end