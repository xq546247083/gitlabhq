require 'spec_helper'

describe Gitlab::GitalyClient::RepositoryService do
  let(:project) { create(:project) }
  let(:storage_name) { project.repository_storage }
  let(:relative_path) { project.disk_path + '.git' }
  let(:client) { described_class.new(project.repository) }

  describe '#exists?' do
    it 'sends a repository_exists message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:repository_exists)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(exists: true))

      client.exists?
    end
  end

  describe '#cleanup' do
    it 'sends a cleanup message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:cleanup)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))

      client.cleanup
    end
  end

  describe '#garbage_collect' do
    it 'sends a garbage_collect message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:garbage_collect)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(:garbage_collect_response))

      client.garbage_collect(true)
    end
  end

  describe '#repack_full' do
    it 'sends a repack_full message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:repack_full)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(:repack_full_response))

      client.repack_full(true)
    end
  end

  describe '#repack_incremental' do
    it 'sends a repack_incremental message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:repack_incremental)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(:repack_incremental_response))

      client.repack_incremental
    end
  end

  describe '#repository_size' do
    it 'sends a repository_size message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:repository_size)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(size: 0)

      client.repository_size
    end
  end

  describe '#apply_gitattributes' do
    let(:revision) { 'master' }

    it 'sends an apply_gitattributes message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:apply_gitattributes)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(:apply_gitattributes_response))

      client.apply_gitattributes(revision)
    end
  end

  describe '#info_attributes' do
    it 'reads the info attributes' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:get_info_attributes)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return([])

      client.info_attributes
    end
  end

  describe '#has_local_branches?' do
    it 'sends a has_local_branches message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:has_local_branches)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(value: true))

      expect(client.has_local_branches?).to be(true)
    end
  end

  describe '#fetch_remote' do
    let(:ssh_auth) { double(:ssh_auth, ssh_import?: true, ssh_key_auth?: false, ssh_known_hosts: nil) }
    let(:import_url) { 'ssh://example.com' }

    it 'sends a fetch_remote_request message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:fetch_remote)
        .with(gitaly_request_with_params(no_prune: false), kind_of(Hash))
        .and_return(double(value: true))

      client.fetch_remote(import_url, ssh_auth: ssh_auth, forced: false, no_tags: false, timeout: 60)
    end
  end

  describe '#rebase_in_progress?' do
    let(:rebase_id) { 1 }

    it 'sends a repository_rebase_in_progress message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:is_rebase_in_progress)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(in_progress: true))

      client.rebase_in_progress?(rebase_id)
    end
  end

  describe '#squash_in_progress?' do
    let(:squash_id) { 1 }

    it 'sends a repository_squash_in_progress message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:is_squash_in_progress)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(in_progress: true))

      client.squash_in_progress?(squash_id)
    end
  end

  describe '#calculate_checksum' do
    it 'sends a calculate_checksum message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:calculate_checksum)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double(checksum: 0))

      client.calculate_checksum
    end
  end

  describe '#create_from_snapshot' do
    it 'sends a create_repository_from_snapshot message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:create_repository_from_snapshot)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double)

      client.create_from_snapshot('http://example.com?wiki=1', 'Custom xyz')
    end
  end

  describe '#raw_changes_between' do
    it 'sends a create_repository_from_snapshot message' do
      expect_any_instance_of(Gitaly::RepositoryService::Stub)
        .to receive(:get_raw_changes)
        .with(gitaly_request_with_path(storage_name, relative_path), kind_of(Hash))
        .and_return(double)

      client.raw_changes_between('deadbeef', 'deadpork')
    end
  end
end
