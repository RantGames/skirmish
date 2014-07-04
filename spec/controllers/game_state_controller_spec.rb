require 'rails_helper'

RSpec.describe GameStateController, :type => :controller do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    pending
    it "returns game_state in json" do


      get 'show/1'

      expect(   .to_json)to equal("{players:[{id:1,name:'ubermouse',cities:[{id:1,name:'Copenhagen',latitude:55.6712674,longitude:12.5608388,units:[{id:1,type:'infantry',attack:1,defense:1},{id:2,type:'infantry',attack:1,defense:1},]}]},{id:2,name:'widdershin',cities:[{id:2,name:'Wellington',latitude:-41.2443701,longitude:174.7618546,units:[{id:3,unit_type:'infantry',attack:1,defense:1},{id:4,unit_type:'infantry',attack:1,defense:1},{id:5,unit_type:'infantry',attack:1,defense:1},]}]}]}")

    end
  end

end
