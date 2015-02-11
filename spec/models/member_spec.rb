require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:event_yakiniku) {create :event, name: '焼き肉パーティ'}
  let(:group_men) {create :group, name: '男性グループ', event: event_yakiniku}
  let(:member_takashi) {create :member, name: 'たかし'}
  let(:group_women) {create :group, name: '女性グループ', event: event_yakiniku}
  let(:member_hiromi) {create :member, name: 'ひろみ'}

  let(:event_karaoke) {create :event, name: 'カラオケパーティ'}
  let(:group_20s) {create :group, name: '20代グループ', event: event_karaoke}
  let(:member_sachiko) {create :member, name: 'さちこ'}
  let(:group_50s) {create :group, name: '50代グループ', event: event_karaoke}
  let(:member_yuzo) {create :member, name: 'ゆうぞう'}

  let!(:member_taro) {create :member, name: 'たろう'}
  before do
    create :group_member, group: group_men, member: member_takashi
    create :group_member, group: group_women, member: member_hiromi
    create :group_member, group: group_20s, member: member_sachiko
    create :group_member, group: group_50s, member: member_yuzo
  end
  shared_examples 'valid members' do
    example do
      expect(subject).to contain_exactly(member_takashi, member_hiromi, member_taro)
    end
  end
  describe '::not_joined_to' do
    subject { Member.not_joined_to(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::scope_not_joined_to' do
    subject { Member.scope_not_joined_to(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::squeel_not_joined_to' do
    subject { Member.squeel_not_joined_to(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::sql_not_joined_to' do
    subject { Member.sql_not_joined_to(event_karaoke) }
    it_behaves_like 'valid members'
  end
end
