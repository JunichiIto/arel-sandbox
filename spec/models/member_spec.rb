require 'rails_helper'

RSpec.describe Member, type: :model do
  # たかし => 焼き肉、Ruby勉強会
  # まさる => 焼き肉、カラオケ
  # ひろみ => 焼き肉
  # さちこ => カラオケ
  # たくや => カラオケ
  # たろう => （参加履歴無し）
  # カラオケに参加してないメンバー => たかし、ひろみ、たろう
  let(:event_yakiniku) {create :event, name: '焼き肉パーティ'}
  let(:group_men) {create :group, name: '男性グループ', event: event_yakiniku}
  let(:member_takashi) {create :member, name: 'たかし'}
  let(:member_masaru) {create :member, name: 'まさる'}
  let(:group_women) {create :group, name: '女性グループ', event: event_yakiniku}
  let(:member_hiromi) {create :member, name: 'ひろみ'}

  let(:event_karaoke) {create :event, name: 'カラオケパーティ'}
  let(:group_20s) {create :group, name: '20代グループ', event: event_karaoke}
  let(:member_sachiko) {create :member, name: 'さちこ'}
  let(:group_50s) {create :group, name: '50代グループ', event: event_karaoke}
  let(:member_takuya) {create :member, name: 'たくや'}

  let(:event_ruby) {create :event, name: 'Ruby勉強会'}
  let(:group_programmer) {create :group, name: 'プログラマグループ', event: event_ruby}

  # グループに属さないユーザー
  let!(:member_taro) {create :member, name: 'たろう'}

  before do
    # グループとメンバーの関連を作成
    create :group_member, group: group_men, member: member_takashi
    create :group_member, group: group_men, member: member_masaru
    create :group_member, group: group_women, member: member_hiromi
    create :group_member, group: group_20s, member: member_sachiko
    create :group_member, group: group_50s, member: member_takuya

    # たかしとまさるは複数のグループに参加している
    create :group_member, group: group_programmer, member: member_takashi
    create :group_member, group: group_20s, member: member_masaru
  end

  # カラオケパーティに参加していないメンバーのみが抽出されることを期待する
  shared_examples 'valid members' do
    it { is_expected.to contain_exactly(member_takashi, member_hiromi, member_taro) }
  end

  describe '::active_record_no_participation_in', pending: 'まさるが抽出されてしまう' do
    subject { Member.active_record_no_participation_in(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::squeel_no_participation_in', pending: 'まさるが抽出されてしまう' do
    subject { Member.squeel_no_participation_in(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::sql_no_participation_in' do
    subject { Member.sql_no_participation_in(event_karaoke) }
    it_behaves_like 'valid members'
  end
  describe '::arel_no_participation_in' do
    subject { Member.arel_no_participation_in(event_karaoke) }
    it_behaves_like 'valid members'
  end

  # アクティブかどうかも条件に加える
  context 'with active' do
    before do
      # ひろみを非アクティブに変更
      member_hiromi.active = false
      member_hiromi.save!
    end

    # カラオケパーティに参加しておらず、かつアクティブなメンバーのみが抽出されることを期待する
    shared_examples 'valid active members' do
      it { is_expected.to contain_exactly(member_takashi, member_taro) }
    end

    describe '::active_record_no_participation_in', pending: 'まさるが抽出されてしまう' do
      subject { Member.active_record_no_participation_in(event_karaoke).active }
      it_behaves_like 'valid active members'
    end
    describe '::squeel_no_participation_in', pending: 'まさるが抽出されてしまう' do
      subject { Member.squeel_no_participation_in(event_karaoke).active }
      it_behaves_like 'valid active members'
    end
    describe '::sql_no_participation_in' do
      subject { Member.sql_no_participation_in(event_karaoke).active }
      it_behaves_like 'valid active members'
    end
    describe '::arel_no_participation_in' do
      subject { Member.arel_no_participation_in(event_karaoke).active }
      it_behaves_like 'valid active members'
    end
  end
end
