#
# '/script/enable_all_features'
#
# rails runner enable_all_features
# turns on all feature flags that are listed in
# /config/feature_flag_names

Feature.configure_all
Feature.activate_all
