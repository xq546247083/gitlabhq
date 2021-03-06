import Vue from 'vue';
import store from '~/ide/stores';
import commitSidebarList from '~/ide/components/commit_sidebar/list.vue';
import { createComponentWithStore } from 'spec/helpers/vue_mount_component_helper';
import { file, resetStore } from '../../helpers';

describe('Multi-file editor commit sidebar list', () => {
  let vm;

  beforeEach(() => {
    const Component = Vue.extend(commitSidebarList);

    vm = createComponentWithStore(Component, store, {
      title: 'Staged',
      fileList: [],
      iconName: 'staged',
      action: 'stageAllChanges',
      actionBtnText: 'stage all',
      itemActionComponent: 'stage-button',
    });

    vm.$store.state.rightPanelCollapsed = false;

    vm.$mount();
  });

  afterEach(() => {
    vm.$destroy();

    resetStore(vm.$store);
  });

  describe('with a list of files', () => {
    beforeEach(done => {
      const f = file('file name');
      f.changed = true;
      vm.fileList.push(f);

      Vue.nextTick(done);
    });

    it('renders list', () => {
      expect(vm.$el.querySelectorAll('li').length).toBe(1);
    });
  });

  describe('empty files array', () => {
    it('renders no changes text when empty', () => {
      expect(vm.$el.textContent).toContain('No changes');
    });
  });
});
