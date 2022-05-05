--Neural Network set up originally made by ChickenSauceSandwich, Discord: Bald man with no hair#8606
--edited by me, GForcebot, Discord: G Kitteh Cat#7884
local NeuralNetwork = {}
function bool2int(bool)
	if bool == true then
		return 1
	else
		return 0
	end
end
local learningRate = .0008
--sigmoid activation function
function sigmoid(activation)
	return 1.0/(1.0+math.exp(-activation))
end

function initNeuron(inputs)
	local neuron = {weights = {}, inputs = {}, activation = 0, delta = 0}

	--initialize input weights 
	for w=1,inputs do
		table.insert(neuron.weights, math.random()*(1-(-1)) - 1)
	end

	--initialize bias weight
	table.insert(neuron.weights, 0)

	return neuron
end

function getActivation(neuron, activationf)
	local activation = neuron.weights[#neuron.weights]

	for w=1,#neuron.weights - 1 do
		activation += neuron.inputs[w] * neuron.weights[w]
	end

	if activationf=="sigmoid" then
		activation = sigmoid(activation)
	elseif activationf=="tanh" then
		activation = math.tanh(activation)
	elseif activationf=="LeakyReLU" then
		activation = math.max(activation * 0.01, activation)
	elseif activationf=="ReLU" then
		activation  = math.max(0,activation)
	end

	return activation
end

--get slope of activation
function transferDerivative(activationf, activation)
	if activationf=="sigmoid" then
		activation = sigmoid(activation) * (1 - sigmoid(activation))
	elseif activationf=="tanh" then
		activation = 1 - math.tanh(activation)^2
	elseif activationf=="LeakyReLU" then
		if activation < 0 then
			activation = 0.01
		else
			activation = 1
		end
	elseif	activationf=="ReLU" then
		if activation > 0 then
			return 1
		else
			return 0
		end 
	else
		activation = 1
	end

	return activation
end
local activationFuncs = {"sigmoid","LeakyReLU","LeakyReLU","sigmoid"}
--calculates network output
function propogateForward(input)
	local oldInput = {}
	for l,layer in pairs(NeuralNetwork) do
		local newInput = {}
		for n,neuron in pairs(layer) do
			if #neuron.inputs > 0 then neuron.inputs = {} end

			if l == 1 then
				table.insert(neuron.inputs, input[n])
			else
				neuron.inputs = oldInput
			end

			--get activation
			local activation = getActivation(neuron,activationFuncs[l])
			neuron.activation = activation
			table.insert(newInput, activation)
		end
		oldInput = newInput
		newInput = {}
	end
	return oldInput
end
--calculates the error of the network
function propogateBackwards(label)
	local lastLayer = {}
	for l=#NeuralNetwork,1,-1 do
		local losses = {}
		if l ~= #NeuralNetwork then
			for n,neuron in pairs(NeuralNetwork[l]) do
				--calculate loss of hidden neurons
				local loss = 0
				for pn,pneuron in pairs(lastLayer) do
					loss += pneuron.weights[n] * pneuron.delta
				end
				table.insert(losses,loss)
			end
		else
			for n,neuron in pairs(NeuralNetwork[l]) do
				table.insert(losses,neuron.activation - label[n])
			end
		end

		for n,neuron in pairs(NeuralNetwork[l]) do
			neuron.delta = losses[n] * transferDerivative(activationFuncs[l], neuron.activation)
		end

		losses = {}
		lastLayer = NeuralNetwork[l]
	end
end

--function to update neuron weights
function updateNetwork()
	for l,layer in pairs(NeuralNetwork) do
		for n,neuron in pairs(layer) do
			for i,input in pairs(neuron.inputs) do
				neuron.weights[i] -= learningRate * neuron.delta * neuron.inputs[i]
			end

			--update bias weight
			neuron.weights[#neuron.weights] -= learningRate * neuron.delta
		end
	end
end
--input layer
local layers = {}
for i = 1,3 do
	local neur = initNeuron(1)
	table.insert(layers,neur)
end
table.insert(NeuralNetwork, layers)
--hidden
local layers = {}
for i = 1,7 do
	local neuron = {}
	neuron = initNeuron(3)
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)
local layers = {}
for i = 1,7 do
	local neuron = {}
	neuron = initNeuron(7)
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)
--output
local layers = {}
for i = 1,3 do
	local neuron = initNeuron(7) 
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)

local debris = game:GetService("Debris")
local max = 1016.8157
local worldmodel = Instance.new("WorldModel",script)
local tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(.05,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,0,false,0)
--task.spawn(function()
--	while task.wait() do
--		local raycast = workspace:Raycast(owner.Character.Head.Position,owner.Character.Head.CFrame.LookVector*1000)
--		if raycast and raycast.Instance then
--			pos = raycast.Position
--		else
--			pos = owner.Character.Head.Position
--		end
--	end
--end)
for i = 1,math.huge do
	task.wait(.01)
	local block = Instance.new("Part",worldmodel)
	block.BrickColor = BrickColor.Black()
	block.Material = Enum.Material.SmoothPlastic
	--block.Position = Vector3.one*math.random(-100,100)
	--block.Size = Vector3.one*math.random(0,100)

	local desired = owner.Character.HumanoidRootPart.Position
	output = propogateForward({block.Position.X/desired.X,block.Position.Y/desired.Y,block.Position.Z/desired.Z})
	propogateBackwards({desired.X/desired.X,desired.Y/desired.Y,desired.Z/desired.Z})
	updateNetwork()
	block.Position = Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)
	block.Size = Vector3.one
	if block.Position ~=  desired then
		block.Transparency = .45
		--print(desired-Vector3.new(output[1],output[2],output[3]))
		debris:AddItem(block,.1)
	else
		print("Try # "..i.. " did it.")
		break
	end
end
