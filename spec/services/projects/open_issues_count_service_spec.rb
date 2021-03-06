require 'spec_helper'

describe Projects::OpenIssuesCountService do
  describe '#count' do
    let(:project) { create(:project) }

    context 'when user is nil' do
      it 'does not include confidential issues in the issue count' do
        create(:issue, :opened, project: project)
        create(:issue, :opened, confidential: true, project: project)

        expect(described_class.new(project).count).to eq(1)
      end
    end

    context 'when user is provided' do
      let(:user) { create(:user) }

      context 'when user can read confidential issues' do
        before do
          project.add_reporter(user)
        end

        it 'returns the right count with confidential issues' do
          create(:issue, :opened, project: project)
          create(:issue, :opened, confidential: true, project: project)

          expect(described_class.new(project, user).count).to eq(2)
        end

        it 'uses total_open_issues_count cache key' do
          expect(described_class.new(project, user).cache_key_name).to eq('total_open_issues_count')
        end
      end

      context 'when user cannot read confidential issues' do
        before do
          project.add_guest(user)
        end

        it 'does not include confidential issues' do
          create(:issue, :opened, project: project)
          create(:issue, :opened, confidential: true, project: project)

          expect(described_class.new(project, user).count).to eq(1)
        end

        it 'uses public_open_issues_count cache key' do
          expect(described_class.new(project, user).cache_key_name).to eq('public_open_issues_count')
        end
      end
    end
  end
end
