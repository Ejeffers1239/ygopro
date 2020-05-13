--burn_counter={[0]=0,[1]=0}
deckdes_counter={[0]=0,[1]=0}
function aux.PreloadUds()
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCode(EFFECT_SKIP_M2)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
	e2:SetTargetRange(1,1)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetOperation(function()
		return 0x00110011
	end)
	Duel.RegisterEffect(e2,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCode(EFFECT_MAX_SZONE)
    e2:SetValue(function(e,tp)
      local pused=2-Duel.GetLocationCount(tp,LOCATION_PZONE)
      return 3-pused
    end)
	Duel.RegisterEffect(e2,0)
    local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetValue(function(e,re,ev,r,rp,rc)
		if r&REASON_EFFECT>0 and ev>=2000 then
            return 0
        else
            return ev
        end
	end)
	Duel.RegisterEffect(e2,0)

--[[	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			burn_counter[p]=0
	--		deckdes_counter[p]=0
		end
	end)
	Duel.RegisterEffect(e2,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep~=rp and r&REASON_EFFECT>0
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		burn_counter[rp]=burn_counter[rp]+ev
		if burn_counter[rp]>=2000 then
			Duel.Win(1-rp,1)
		end
	end)
	Duel.RegisterEffect(e2,0)]]
    local e
	local function f(c)
		local p=c:GetReasonPlayer()
		return c:IsPreviousLocation(LOCATION_DECK) and c:IsControler(1-p)
	end
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(f,1,nil)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(f,nil)
		for tc in aux.Next(g) do
			local p=tc:GetReasonPlayer()
			deckdes_counter[p]=deckdes_counter[p]+1
			if deckdes_counter[p]>=6 then
				Duel.Win(1-p,1)
			end
		end
	end)
	Duel.RegisterEffect(e2,0)
end
