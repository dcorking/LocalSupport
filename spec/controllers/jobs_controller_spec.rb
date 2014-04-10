require 'spec_helper'

describe JobsController do
  let(:user) { stub_model User }
  let(:org) { stub_model Organization, id: '1' }
  let(:job) { stub_model Job, id: '9' }
  let(:jobs_collection) { double :jobs_collection }
  before do
    org.stub jobs: jobs_collection
    job.stub organization: org
    jobs_collection.stub find: job
    Organization.stub find: org
  end

  describe 'GET index' do
    it 'assigns all jobs as @jobs' do
      get :index, { organization_id: org.id }
      assigns(:jobs).should eq jobs_collection
    end
    it 'non-org-owners allowed' do
      controller.stub current_user: user, org_owner?: false
      get :index, { organization_id: org.id }
      response.status.should eq 200
    end
    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id) { org }
      org.should_receive(:jobs)
      get :index, { organization_id: org.id }
    end
  end

  describe 'GET show' do
    it 'assigns the requested job as @job' do
      get :show, { organization_id: org.id, id: job.id }
      assigns(:job).should eq job
    end
    it 'non-org-owners allowed' do
      controller.stub current_user: user, org_owner?: false
      get :show, { organization_id: org.id, id: job.id }
      response.status.should eq 200
    end
    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id) { org }
      org.should_receive(:jobs) { jobs_collection }
      jobs_collection.should_receive(:find)
      get :show, { organization_id: org.id, id: job.id }
    end
  end

  describe 'GET new' do
    before do
      controller.stub current_user: user, org_owner?: true
      org.stub job: jobs_collection
      jobs_collection.stub build: job
    end
    it 'assigns a new job as @job' do
      get :new, { organization_id: org.id }
      assigns(:job).should eq job
    end
    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :new, { organization_id: org.id }
      response.status.should eq 302
    end
    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id) { org }
      org.should_receive(:jobs) { jobs_collection }
      jobs_collection.should_receive(:build)
      get :new, { organization_id: org.id }
    end

  end

  describe 'GET edit' do
    before do
      controller.stub current_user: user, org_owner?: true
      org.stub jobs: jobs_collection
      jobs_collection.stub find: job
    end
    it 'assigns the requested job as @job' do
      get :edit, {organization_id: org.id, :id => job.id}
      assigns(:job).should eq(job)
    end
    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :edit, {organization_id: org.id, :id => job.id}
      response.status.should eq 302
    end
    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id) { org }
      org.should_receive(:jobs) { jobs_collection }
      jobs_collection.should_receive(:find)
      get :edit, {organization_id: org.id, :id => job.id}
    end
  end

  describe 'POST create' do
    let(:valid_attributes) { {title: 'hard work', description: 'for the willing'} }
    let(:invalid_attributes) { {title: 'hard work'} }

    before do
      controller.stub current_user: user, org_owner?: true
      org.stub job: jobs_collection
      jobs_collection.stub build: job
    end

    describe 'with valid params' do
      # TODO make this to a request spec
      # it 'creates a new Job' do
      #   expect {
      #     post :create, {:job => valid_attributes}, valid_session
      #   }.to change(Job, :count).by(1)
      # end

      it 'assigns a newly created job as @job' do
        job.stub save: true
        post :create, { organization_id: org.id, job: valid_attributes }
        assigns(:job).should eq job
      end

      it 'redirects to the created job' do
        job.stub save: true
        post :create, { organization_id: org.id, job: valid_attributes }
        response.should redirect_to([org, job])
      end

    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved job as @job' do
        Job.any_instance.stub(:save).and_return(false)
        post :create, {organization_id: org.id, job: invalid_attributes}
        assigns(:job).should eq job
      end

      it 're-renders the "new" template' do
        Job.any_instance.stub(:save).and_return(false)
        post :create, {organization_id: org.id, job: invalid_attributes}
        response.should render_template('new')
      end
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      post :create, { organization_id: org.id, job: valid_attributes }
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id.to_s) { org }
      org.should_receive(:jobs) { jobs_collection }
      jobs_collection.should_receive(:build)
      post :create, { organization_id: org.id, job: valid_attributes }
    end
  end

  describe 'PUT update' do
    let(:valid_attributes) { {title: 'hard work', description: 'for the willing'} }
    let(:invalid_attributes) { {title: 'hard work'} }

    before do
      controller.stub current_user: user, org_owner?: true
      org.stub job: jobs_collection
      jobs_collection.stub build: job
    end

    describe 'with valid params' do
      # TODO move to request spec
      # it 'updates the requested job' do
      #   job = Job.create! valid_attributes
      #   # Assuming there are no other jobs in the database, this
      #   # specifies that the Job created on the previous line
      #   # receives the :update_attributes message with whatever params are
      #   # submitted in the request.
      #   Job.any_instance.should_receive(:update_attributes).with({'title' => 'MyString'})
      #   put :update, {:id => job.to_param, :job => {'title' => 'MyString'}}, valid_session
      # end

      it 'assigns the requested job as @job' do
        job.stub update_attributes: true
        put :update, { organization_id: org.id, id: job.id, job: valid_attributes }
        assigns(:job).should eq job
      end

      it 'redirects to the job' do
        job.stub update_attributes: true
        put :update, { organization_id: org.id, id: job.id, job: valid_attributes }
        response.should redirect_to([org, job])
      end
    end

    describe 'with invalid params' do
      it 'assigns the job as @job' do
        Job.any_instance.stub(:update_attributes).and_return(false)
        put :update, { organization_id: org.id, id: job.id, job: invalid_attributes }
        assigns(:job).should eq job
      end

      it 're-renders the "edit" template' do
        Job.any_instance.stub(:update_attributes).and_return(false)
        put :update, { organization_id: org.id, id: job.id, job: invalid_attributes }
        response.should render_template('edit')
      end
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      put :update, { organization_id: org.id, id: job.id, job: valid_attributes }
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      Organization.should_receive(:find).with(org.id.to_s) { org }
      org.should_receive(:jobs) { jobs_collection }
      jobs_collection.should_receive(:find).with(job.id) { job }
      job.should_receive.update_attributes.with(valid_attributes)
      put :update, { organization_id: org.id, id: job.id, job: valid_attributes }
    end

  end

  describe 'DELETE destroy' do
    it 'destroys the requested job' do
      job = Job.create! valid_attributes
      expect {
        delete :destroy, {:id => job.to_param}, valid_session
      }.to change(Job, :count).by(-1)
    end

    it 'redirects to the jobs list' do
      job = Job.create! valid_attributes
      delete :destroy, {:id => job.to_param}, valid_session
      response.should redirect_to(jobs_url)
    end
  end
end
