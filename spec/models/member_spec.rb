require 'rails_helper'

RSpec.describe Member, type: :model do
  describe '::not_joined_to' do
    example do
      event_yakiniku = create :event, name: '焼き肉パーティ'
      group_men = create :group, name: '男性グループ', event: event_yakiniku
      member_takashi = create :member, name: 'たかし'
      create :group_member, group: group_men, member: member_takashi
      group_women = create :group, name: '女性グループ', event: event_yakiniku
      member_hiromi = create :member, name: 'ひろみ'
      create :group_member, group: group_women, member: member_hiromi

      event_karaoke = create :event, name: 'カラオケパーティ'
      group_20s = create :group, name: '20代グループ', event: event_karaoke
      member_sachiko = create :member, name: 'さちこ'
      create :group_member, group: group_20s, member: member_sachiko
      group_50s = create :group, name: '50代グループ', event: event_karaoke
      member_yuzo = create :member, name: 'ゆうぞう'
      create :group_member, group: group_50s, member: member_yuzo

      member_taro = create :member, name: 'たろう'

      members = Member.not_joined_to(event_karaoke)
      expect(members.count).to eq 3
      expect(members).to contain_exactly(member_takashi, member_hiromi, member_taro)
    end
  end
end
