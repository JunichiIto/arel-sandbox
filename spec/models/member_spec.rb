require 'rails_helper'

RSpec.describe Member, type: :model do
  describe '::not_joined_to' do
    example do
      event_yakiniku = create :event, name: '焼き肉パーティ'
      group_men = create :group, name: '男性グループ', event: event_yakiniku
      member_takashi = create :member, name: 'たかし'
      create :group_member, group: group_men, member: member_takashi

      event_karaoke = create :event, name: 'カラオケパーティ'
      group_20s = create :group, name: '20代グループ', event: event_karaoke
      member_sachiko = create :member, name: 'さちこ'
      create :group_member, group: group_20s, member: member_sachiko

      members = Member.not_joined_to(event_karaoke)
      expect(members.count).to eq 1
      expect(members.first).to eq member_takashi
    end
  end
end
